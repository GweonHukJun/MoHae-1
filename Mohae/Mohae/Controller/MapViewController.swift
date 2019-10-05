//
//  ViewController.swift
//  Mohae
//
//  Created by 권혁준 on 06/08/2019.
//  Copyright © 2019 이주영. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass
import GoogleMaps
import GooglePlaces
import SwiftyJSON
import SnapKit

private enum State {
    case closed
    case open
}

extension State {
    var opposite: State {
        switch self {
        case .open: return .closed
        case .closed: return .open
        }
    }
}

class MapViewController: UIViewController {
    
    var json : JSON?
    var defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)
    
    let popupOffset: CGFloat = 440
    
    var bottomConstraint = NSLayoutConstraint()
  
    var placesClient : GMSPlacesClient!
    var zoomLevel : Float = 15.0
    
    let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location="
    let radiusType = "&language=ko&rankby=distance&type="
    let search = "restaurant"
    let key = "&key="
    
    private var currentState: State = .closed
    private var runningAnimators = [UIViewPropertyAnimator]()
    private var animationProgress = [CGFloat]()
      
    private lazy var panRecognizer: InstantPanGestureRecognizer = {
          let recognizer = InstantPanGestureRecognizer()
          recognizer.addTarget(self, action: #selector(popupViewPanned(recognizer:)))
          return recognizer
      }()
    
    var downBar : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 10
        return view
    }()
    
    lazy var overLayout: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()
    
    lazy var closeBar: UILabel = { //닫혀있을 때 나오는 글자
        let label = UILabel()
        label.text = "List Open"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        label.textColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    lazy var openBar: UILabel = { //열려있을때 나오는 글자
        let label = UILabel()
        label.text = "List"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 23, weight: UIFont.Weight.heavy)
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.alpha = 0
        label.textAlignment = .center
        label.transform = CGAffineTransform(scaleX: 0.65, y: 0.65).concatenating(CGAffineTransform(translationX: 0, y: -15))
        return label
    }()
    
    lazy var collectionList : UICollectionView = {
        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 60, height: 60)
        let CV = UICollectionView(frame:  self.view.frame, collectionViewLayout: layout)
        CV.translatesAutoresizingMaskIntoConstraints = false
        CV.register(MapSearchCell.self, forCellWithReuseIdentifier: "MapSearchCell")
        CV.backgroundColor = .white
        return CV
    }()
    
    lazy var mapView : GMSMapView = {
        var view = GMSMapView()
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude, longitude: defaultLocation.coordinate.longitude, zoom: zoomLevel) // 구글 지도에 표기될 내 현 위치를 입력시켜둠
        view = GMSMapView.map(withFrame: view.bounds, camera: camera) //구글 지도 열었을 때 카메라 위치 및 내 위치 지정
        view.settings.zoomGestures = false
        view.settings.rotateGestures = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isMyLocationEnabled = true
        view.isHidden = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        collectionList.delegate = self //collectionview를 사용하기 위해서 작성
        collectionList.dataSource = self
        
        placesClient = GMSPlacesClient.shared() //구글 places APi 사용을 위해서 추가
        
        //navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem:.add,target: self, action:#selector(menuBtn)) //네비게이션 추가
        
        setup()
        downBar.addGestureRecognizer(panRecognizer)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func animateTransitionIfNeeded(to state: State, duration: TimeInterval) {
        
        guard runningAnimators.isEmpty else { return }

        let transitionAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1, animations: {
            switch state {
            case .open:
                self.bottomConstraint.constant = 0
                self.downBar.layer.cornerRadius = 20
                UIView.animate(withDuration: 1){
                    self.downBar.center = CGPoint(x: self.view.frame.midX, y: self.view.bounds.size.height*0.4-30)
                }
                UIView.animate(withDuration: 1){
                    self.collectionList.center = CGPoint(x:
                        self.view.frame.midX, y: self.view.bounds.size.height*0.7 )
                }
                self.overLayout.alpha = 0.5
                self.closeBar.transform = CGAffineTransform(scaleX: 1.6, y: 1.6).concatenating(CGAffineTransform(translationX: 0, y: 15))
                self.openBar.transform = .identity
            case .closed:
                self.bottomConstraint.constant = self.popupOffset
                self.downBar.layer.cornerRadius = 0
                UIView.animate(withDuration: 1){
                    self.downBar.center = CGPoint(x: self.view.frame.midX, y: self.view.bounds.size.height-30)
                }
                UIView.animate(withDuration: 1){
                    self.collectionList.center = CGPoint(x:
                        self.view.frame.midX, y: self.view.bounds.size.height + self.view.bounds.size.height*0.3 )
                }
                self.overLayout.alpha = 0
                self.closeBar.transform = .identity
                self.openBar.transform = CGAffineTransform(scaleX: 0.65, y: 0.65).concatenating(CGAffineTransform(translationX: 0, y: -15))
            }
            self.view.layoutIfNeeded()
        })
        
        // the transition completion block
        transitionAnimator.addCompletion { position in
            
            // update the state
            switch position {
                case .start:
                    self.currentState = state.opposite
                case .end:
                    self.currentState = state
                case .current:
                    ()
            }
            
            // manually reset the constraint positions
            switch self.currentState {
            case .open:
                self.bottomConstraint.constant = 0
            case .closed:
                self.bottomConstraint.constant = self.popupOffset
            }
            
            // remove all running animators
            self.runningAnimators.removeAll()
            
        }
        
        // an animator for the title that is transitioning into view
        let inTitleAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeIn, animations: {
            switch state {
            case .open:
                self.openBar.alpha = 1
            case .closed:
                self.closeBar.alpha = 1
            }
        })
        inTitleAnimator.scrubsLinearly = false
        
        // an animator for the title that is transitioning out of view
        let outTitleAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeOut, animations: {
            switch state {
            case .open:
                self.closeBar.alpha = 0
            case .closed:
                self.openBar.alpha = 0
            }
        })
        outTitleAnimator.scrubsLinearly = false
        
        // start all animators
        transitionAnimator.startAnimation()
        inTitleAnimator.startAnimation()
        outTitleAnimator.startAnimation()
        
        // keep track of all running animators
        runningAnimators.append(transitionAnimator)
        runningAnimators.append(inTitleAnimator)
        runningAnimators.append(outTitleAnimator)
        
    }
    
    @objc private func popupViewPanned(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            
            // start the animations
            animateTransitionIfNeeded(to: currentState.opposite, duration: 1)
            
            // pause all animations, since the next event may be a pan changed
            runningAnimators.forEach { $0.pauseAnimation() }
            
            // keep track of each animator's progress
            animationProgress = runningAnimators.map { $0.fractionComplete }
            
        case .changed:
            
            // variable setup
            let translation = recognizer.translation(in: downBar)
            var fraction = -translation.y / popupOffset
            
            // adjust the fraction for the current state and reversed state
            if currentState == .open { fraction *= -1 }
            if runningAnimators[0].isReversed { fraction *= -1 }
            
            // apply the new fraction
            for (index, animator) in runningAnimators.enumerated() {
                animator.fractionComplete = fraction + animationProgress[index]
            }
            
        case .ended:
            
            // variable setup
            let yVelocity = recognizer.velocity(in: downBar).y
            let shouldClose = yVelocity > 0
            
            // if there is no motion, continue all animations and exit early
            if yVelocity == 0 {
                runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
                break
            }
            
            // reverse the animations based on their current state and pan motion
            switch currentState {
            case .open:
                if !shouldClose && !runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                if shouldClose && runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
            case .closed:
                if shouldClose && !runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                if !shouldClose && runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
            }
            
            // continue all animations
            runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
            
        default:
            ()
        }
    }
}

class InstantPanGestureRecognizer: UIPanGestureRecognizer {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if (self.state == UIGestureRecognizer.State.began) { return }
        super.touchesBegan(touches, with: event)
        self.state = UIGestureRecognizer.State.began
    }
    
}


extension MapViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 19
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MapSearchCell", for: indexPath) as! MapSearchCell
        cell.backgroundColor = .yellow
        cell.name.text = json?["results"][indexPath.row]["name"].stringValue
        cell.type.text = json?["results"][indexPath.row]["types"][0].stringValue
       
        cell.type2.text = json?["results"][indexPath.row]["types"][1].stringValue
        cell.id = json?["results"][indexPath.row]["id"].stringValue
        cell.place_id = json?["results"][indexPath.row]["place_id"].stringValue
        cell.lat = json?["results"][indexPath.row]["geometry"]["location"]["lat"].doubleValue
        cell.lng = json?["results"][indexPath.row]["geometry"]["location"]["lng"].doubleValue
        
        
        return cell
    }
    
    func setup(){
        
        view.addSubview(mapView)
        mapView.snp.makeConstraints { (make) in
           make.leading.equalTo(self.view.snp.leading)
           make.trailing.equalTo(self.view.snp.trailing)
            make.top.equalTo(self.view.snp.top)
            make.bottom.equalTo(self.view.snp.bottom)
        }
        
        view.addSubview(overLayout)
        mapView.snp.makeConstraints { (make) in
           make.leading.equalTo(self.view.snp.leading)
           make.trailing.equalTo(self.view.snp.trailing)
            make.top.equalTo(self.view.snp.top)
            make.bottom.equalTo(self.view.snp.bottom)
        }
        
        view.addSubview(downBar)
        downBar.snp.makeConstraints { (make) in
            make.leading.equalTo(self.view.snp.leading)
            make.trailing.equalTo(self.view.snp.trailing)
            make.bottom.equalTo(self.view.snp.bottom)
            make.height.equalTo(60)
        }
        downBar.addSubview(closeBar)
        closeBar.snp.makeConstraints { (make) in
            make.leading.equalTo(downBar.snp.leading)
            make.trailing.equalTo(downBar.snp.trailing)
            make.top.equalTo(downBar.snp.top).offset(20)
        }
        downBar.addSubview(openBar)
        openBar.snp.makeConstraints { (make) in
            make.leading.equalTo(downBar.snp.leading)
            make.trailing.equalTo(downBar.snp.trailing)
             bottomConstraint = downBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: popupOffset)
            bottomConstraint.isActive = true
            make.top.equalTo(downBar.snp.top).offset(30)
        }
        view.addSubview(collectionList)
        collectionList.snp.makeConstraints { (make) in
            make.leading.equalTo(self.view.snp.leading)
            make.trailing.equalTo(self.view.snp.trailing)
            make.top.equalTo(self.downBar.snp.bottom)
            make.height.equalTo(self.view.bounds.size.height*0.6)
        }
    }
}
