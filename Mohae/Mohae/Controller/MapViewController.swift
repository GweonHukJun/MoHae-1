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
import Alamofire
//열거형으로 하단바의 상태를 정해준다.
private enum State {
    case closed
    case open
}

//하단바의 상태를 변경해준다.
extension State {
    var opposite: State {
        switch self {
        case .open: return .closed
        case .closed: return .open
        }
    }
}

class MapViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var listHeight : CGFloat = 200
    //activity indicator를 돌게 하기위해서 사용하는 변수
    var isLoading:Bool = false
    let footerViewReuseIdentifier = "RefreshFooterView"
    //구글 place api를 쓰기위해서 만든 객체
    var placesClient : GMSPlacesClient!
    //json데이터를 받기 위해서 만든 함수, AgreeViewController에서 갑을 받는다.
    var item : [JSON] = []
    var itemReady : [JSON] = []
    var jsonCount : Int?
    //내 위치의 초기 값을 설정해준 변수이다. AgreeViewController에서 갑을 받는다.
    var defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)
    //처음 컬렉션뷰에 나오는 데이터를 조절하기 위해서 사용
    var count = 0
    //구글 지도가 줌할 수치를 정하는 변수
    var zoomLevel : Float = 15.0
    //구글의 사진을 받아오는 함수에서 나오는 사진을 저장하기 위해서 사용
    var image : UIImage?
    //구글 place api의 지역 id
    var place_id : String?
    //제스처를 이용하기 위해서 사용하는 변수 ------------ 이건 나중에 좀더 공부해보자
    private var currentState: State = .closed
    private var runningAnimators = [UIViewPropertyAnimator]()
    private var animationProgress = [CGFloat]()
    //팬제스처를 정의함
    private lazy var panReco: UIPanGestureRecognizer = {
        let recognizer = UIPanGestureRecognizer()
        return recognizer
    }()
    private lazy var panRecognizer: InstantPanGestureRecognizer = {
          let recognizer = InstantPanGestureRecognizer()
          recognizer.addTarget(self, action: #selector(popupViewPanned(recognizer:)))
          return recognizer
      }()
    //하단바
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
    //하단바에 나오는 글자
    lazy var closeBar: UILabel = { //닫혀있을 때 나오는 글자
        let label = UILabel()
        label.text = "List Open"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        label.textColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    //하단바에 나오는 글자
    lazy var openBar: UILabel = { //열려있을때 나오는 글자
        let label = UILabel()
        label.text = "List"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 23, weight: UIFont.Weight.medium)
        label.textColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        label.alpha = 0
        label.textAlignment = .center
        label.transform = CGAffineTransform(scaleX: 0.65, y: 0.65).concatenating(CGAffineTransform(translationX: 0, y: -15))
        return label
    }()
    //콜렉션뷰
    lazy var collectionList : UICollectionView = {
        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let CV = UICollectionView(frame:  self.view.frame, collectionViewLayout: layout)
        CV.translatesAutoresizingMaskIntoConstraints = false
        CV.register(MapSearchCell.self, forCellWithReuseIdentifier: "MapSearchCell")
        CV.register(LoadingCell.self, forCellWithReuseIdentifier: "loadingCellIdentifier")
        CV.backgroundColor = .white
        return CV
    }()
    //구글 지도
    lazy var mapView : GMSMapView = {
        var view = GMSMapView()
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude, longitude: defaultLocation.coordinate.longitude, zoom: zoomLevel) // 구글 지도에 표기될 내 현 위치를 입력시켜둠
        view = GMSMapView.map(withFrame: view.bounds, camera: camera) //구글 지도 열었을 때 카메라 위치 및 내 위치 지정
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isMyLocationEnabled = true
        view.isHidden = false
        view.mapType = .normal
        view.isIndoorEnabled = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listHeight = self.view.frame.size.height - (navigationController?.navigationBar.frame.height)! - 60
        //place api를 사용하기 위해서 사용
        placesClient = GMSPlacesClient.shared()
        //collectionview의 delegate설정해줌
        collectionList.delegate = self
        collectionList.dataSource = self
        //제스처의 delegate를 설정
        panRecognizer.delegate = self
        //데이터를 load하는 함수
        refreshData()
        //화면 구성해주는 함수
        setup()
        //하단바의 제스처를 추가
        downBar.addGestureRecognizer(panRecognizer)
        //콜렉션뷰의 데이터를 리로드
       
        //collectionList.gestureRecognizers = [swipeRight]
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추천 다시", style: .plain, target: self, action:#selector(moveFirst))
        self.navigationItem.setHidesBackButton (true, animated : true);
    }
    
    @objc func moveFirst(){
           //뷰의 네비게이션 이동을 카운터로 세서 이동이 2개 초과일때 첫번째 뷰로 이동하게 만들어주는 소스
      if let viewControllers = self.navigationController?.viewControllers {
            if viewControllers.count > 9{
                self.navigationController?.popToViewController(viewControllers[viewControllers.count - 10], animated: true)
            }
        }
          
       }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func animateTransitionIfNeeded(to state: State, duration: TimeInterval) {
        
        
        guard runningAnimators.isEmpty else { return }
        //오픈과 클로스 행동을 할때 애니메이션 설정
        let transitionAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1, animations: {
            switch state {
            case .open : 
                self.downBar.layer.cornerRadius = 20
                self.downBar.center.y = (self.navigationController?.navigationBar.bounds.size.height)! + 30
                self.collectionList.center.y = (self.navigationController?.navigationBar.bounds.size.height)! + self.listHeight/2 + 60
                self.closeBar.transform = CGAffineTransform(scaleX: 1.6, y: 1.6).concatenating(CGAffineTransform(translationX: 0, y: 15))
                self.openBar.transform = .identity
            case .closed :
                self.downBar.layer.cornerRadius = 0
                self.downBar.center.y  = self.view.frame.height-self.downBar.bounds.size.height/2
                self.collectionList.center.y = self.view.frame.height + self.collectionList.frame.height/2
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
        inTitleAnimator.scrubsLinearly = true
        
        // an animator for the title that is transitioning out of view
        let outTitleAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeOut, animations: {
            switch state {
            case .open:
                self.closeBar.alpha = 0
            case .closed:
                self.openBar.alpha = 0
            }
        })
        outTitleAnimator.scrubsLinearly = true
        
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
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MapSearchCell", for: indexPath) as! MapSearchCell
        cell.backgroundColor = .white
        cell.name.text = item[indexPath.row]["name"].stringValue
        cell.address.text = item[indexPath.row]["vicinity"].stringValue
        cell.photo.loadImageUsingCacheWithUrlString(urlString: (item[indexPath.row]["place_id"].stringValue))
        
        
        cell.id = item[indexPath.row]["id"].stringValue
        cell.lat = item[indexPath.row]["geometry"]["location"]["lat"].doubleValue
        cell.lng = item[indexPath.row]["geometry"]["location"]["lng"].doubleValue
        
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCellSelected(sender:))))
        
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
    //셀을 눌렀을 때 지도에 핀이 그려지게하는 함수
       func pinMarker(lat : Double, lng : Double, type : String, name : String){
           mapView.clear()
           let marker = GMSMarker()
           marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
           marker.title = type
           marker.snippet = name
           marker.map = self.mapView
       }
    //count의 수를 늘리면서 json의 수만큼 데이터를 리로드 해준다.
    @objc func refreshData(){
        for i in count...count+6{
            if i <= jsonCount! - 1 {
                item.append(itemReady[i])
            }
        }
        count = count + 6
        DispatchQueue.main.async {
            if self.count <= self.jsonCount!-1{
                self.collectionList.reloadData()
            }
            
        }
    }
    //이 함수는 셀에 제스처를 줘서 클릭했을 때 pinMarker함수가 실행되도록
    @objc func handleCellSelected(sender: UITapGestureRecognizer){
        let cell = sender.view as! MapSearchCell
        let indexPath = collectionList.indexPath(for: cell)
        pinMarker(lat: cell.lat!, lng: cell.lng!, type: cell.address.text!, name: cell.name.text!)
        self.downBar.layer.cornerRadius = 0
        self.downBar.center = CGPoint(x: self.view.frame.midX, y:self.view.frame.height-self.downBar.bounds.size.height/2)
        self.collectionList.center = CGPoint(x:self.view.frame.midX, y: self.view.bounds.size.height*1.45 )
        self.closeBar.transform = .identity
        self.openBar.transform = CGAffineTransform(scaleX: 0.65, y: 0.65).concatenating(CGAffineTransform(translationX: 0, y: -15))
        currentState = currentState.opposite
        closeBar.alpha = 1
        openBar.alpha = 0
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
            make.height.equalTo(listHeight)
        }
    }
    
    /*. 안타깝게도 우리나라에서는 지원하지 않는 api이다. 지원하는 그날 바로 풀고 추가를 하겠다.
       func drawPath(orLat : CLLocationDegrees, orLng : CLLocationDegrees, deLat : Double, deLng : Double)
           {
               let origin = "\(43.1561681),\(-75.8449946)"
               let destination = "\(38.8950712),\(-77.0362758)"


               let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyDyStsE4WHE1YLRVx9uYRFLjqZ3tlEmdrE"



               Alamofire.request(url).responseJSON { response in
                   print(response.request!)  // original URL request
                   print(response.response!) // HTTP URL response
                   print(response.data!)     // server data
                   print(response.result)   // result of response serialization

                   do {
                       let json = try JSON(data: response.data!)
                       let routes = json["routes"].arrayValue

                       for route in routes
                       {
                           let routeOverviewPolyline = route["overview_polyline"].dictionary
                           let points = routeOverviewPolyline?["points"]?.stringValue
                           let path = GMSPath.init(fromEncodedPath: points!)
                           let polyline = GMSPolyline.init(path: path)
                           polyline.map = self.mapView
                       }
                   }
                   catch {
                       print("ERROR: not working")
                   }
               }
           }
    */
}
