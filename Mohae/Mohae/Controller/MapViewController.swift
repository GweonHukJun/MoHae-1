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
import SwiftyJSON
import SnapKit
import GooglePlaces

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

class MapViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var placesClient : GMSPlacesClient!
    var json : JSON?
    var defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)

    var zoomLevel : Float = 15.0

    var image : UIImage?
    var place_id : String?
    
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
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isMyLocationEnabled = true
        view.isHidden = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        placesClient = GMSPlacesClient.shared()
        
        collectionList.delegate = self //collectionview를 사용하기 위해서 작성
        collectionList.dataSource = self
        
        panRecognizer.delegate = self
        
        setup()
        downBar.addGestureRecognizer(panRecognizer)
        collectionList.reloadData()
        //collectionList.gestureRecognizers = [swipeRight]
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func animateTransitionIfNeeded(to state: State, duration: TimeInterval) {
        
        
        guard runningAnimators.isEmpty else { return }

        let transitionAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1, animations: {
            switch state {
            case .open:
                self.downBar.layer.cornerRadius = 20
                self.downBar.center = CGPoint(x: self.view.frame.midX, y: (self.navigationController?.navigationBar.bounds.size.height)!*2+self.downBar.bounds.size.height/2)
                self.collectionList.center = CGPoint(x:self.view.frame.midX, y: (self.navigationController?.navigationBar.bounds.size.height)!*2+self.downBar.bounds.size.height+self.collectionList.bounds.size.height/2)
               
                self.closeBar.transform = CGAffineTransform(scaleX: 1.6, y: 1.6).concatenating(CGAffineTransform(translationX: 0, y: 15))
                self.openBar.transform = .identity
            case .closed:
                self.downBar.layer.cornerRadius = 0
                self.downBar.center = CGPoint(x: self.view.frame.midX, y:self.view.frame.height-self.downBar.bounds.size.height/2)
                self.collectionList.center = CGPoint(x:self.view.frame.midX, y: self.view.bounds.size.height*1.45 )
                self.closeBar.transform = .identity
                self.openBar.transform = CGAffineTransform(scaleX: 0.65, y: 0.65).concatenating(CGAffineTransform(translationX: 0, y: -15))
            }
            
            
            self.view.layoutIfNeeded()
        })
        
        // the transition completion block
        transitionAnimator.addCompletion { position in
            
            // update the state
            switch position {  //현재 downbar가 내려가 있는지 올라와있는지 구별해준다
                case .start:
                    self.currentState = state.opposite
                case .end:
                    self.currentState = state
                case .current:
                    ()
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
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
          return true
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
            let translation = recognizer.translation(in: downBar) //downBar에 크기 구한다.
            var fraction = -translation.y/400  //뷰 올릴 때 한번에 얼마나 올라갈지 정하는 변수
         
            // adjust the fraction for the current state and reversed state
            if currentState == .open { fraction *= -1 } //ㅇ
            if runningAnimators[0].isReversed { fraction *= -1 }
            
            // apply the new fraction
            //enumerated - 쌍의 시퀀스 (n, x)를 반환합니다. 여기서 n은 0에서 시작하는 연속 정수를 나타내고 x는 시퀀스의 요소를 나타냅니다.
            for (index, animator) in runningAnimators.enumerated() {
                animator.fractionComplete = fraction + animationProgress[index]
                //fractionComplete - 이 속성의 값은 애니메이션 시작시 0.0, 애니메이션 끝에서 1.0입니다. 중간 값은 애니메이션 실행의 진행률을 나타냅니다. 예를 들어, 값 0.5는 애니메이션이 정확히 반쯤 완료되었음을 나타냅니다
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
        return CGSize(width: view.frame.width, height: collectionList.frame.height/6)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MapSearchCell", for: indexPath) as! MapSearchCell
        cell.backgroundColor = .yellow
        cell.name.text = json?["results"][indexPath.row]["name"].stringValue
        cell.type.text = json?["results"][indexPath.row]["types"][0].stringValue
        cell.type2.text = json?["results"][indexPath.row]["types"][1].stringValue
        
        if json?["results"][indexPath.row]["place_id"].stringValue != nil{
            self.place_id = json?["results"][indexPath.row]["place_id"].stringValue
            if self.place_id != nil{
                 photo(places: self.place_id!)
                cell.photo.image  = self.image
            }
        }
        cell.id = json?["results"][indexPath.row]["id"].stringValue
        cell.lat = json?["results"][indexPath.row]["geometry"]["location"]["lat"].doubleValue
        cell.lng = json?["results"][indexPath.row]["geometry"]["location"]["lng"].doubleValue
        
        
        return cell
    }
    
    func photo(places:String) {
        
           let placeString = places
           let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.photos.rawValue))!
        placesClient?.fetchPlace(fromPlaceID: places, placeFields: fields, sessionToken: nil, callback: {
                (place: GMSPlace?, error: Error?) in
                if let error = error {
                  print("An error occurred: \(error.localizedDescription)")
                  return
                }
                if let place = place {
                    print(placeString)
                  // Get the metadata for the first photo in the place photo metadata list.
                    if place.photos?[0] != nil {
                        let photoMetadata: GMSPlacePhotoMetadata = place.photos![0]

                      // Call loadPlacePhoto to display the bitmap and attribution.
                      self.placesClient?.loadPlacePhoto(photoMetadata, callback: { (photo, error) -> Void in
                        if let error = error {
                          // TODO: Handle the error.
                          print("Error loading photo metadata: \(error.localizedDescription)")
                          return
                        } else {
                          // Display the first image and its attributions.
                           self.image = photo
                          //self.lblText.attributedText = photoMetadata.attributions;
                        }
                    })
                  } else {
            
                  }
            }}
        )
    }
 
    
    func setup(){
        
        view.addSubview(mapView)
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
            make.top.equalTo(downBar.snp.top).offset(20)
        }
        view.addSubview(collectionList)
        collectionList.snp.makeConstraints { (make) in
            make.leading.equalTo(self.downBar.snp.leading)
            make.trailing.equalTo(self.downBar.snp.trailing)
            make.top.equalTo(self.downBar.snp.bottom)
            make.height.equalTo(self.view.bounds.size.height*0.9)
        }
    }
}
