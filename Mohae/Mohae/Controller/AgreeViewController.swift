//
//  AgreeViewController.swift
//  Mohae
//
//  Created by 권혁준 on 25/09/2019.
//  Copyright © 2019 권혁준. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SwiftyJSON
import SnapKit
// 문제는 itme과 jsonCount에 값이 제대로 입력이 안된다.
class AgreeViewController: UIViewController, CLLocationManagerDelegate {

    //1.5초 후 실행되는 함수를 위해서 시간초를 세어줌
    var timer = Timer()
    var time = 0
    //json데이터 처리 변수들
    var json : JSON?
    var item : [JSON] = []
    var jsonCount : Int?
    
    //구글의 place api를 받아오기 위해서 필요
    var placesClient : GMSPlacesClient!
    //내 위치를 받아오기 위해서 사용
    var locationManager:CLLocationManager?
    //구글 지도의 보이는 확대 레벨을 표기해주는 변수
    var zoomLevel : Float = 15.0
    //내 위치를 받아서 저장할 변수
    var defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)
    //MapViewController의 객체
    var delegate : MapViewController?
    //구글 place api의 데이터들을 불러오기 위해서 사용되는 변수들
    let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location="
    let radiusType = "&language=ko&rankby=distance&type="
    var search = "bank"
    var key = "&key="
    
    let url2 = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location="
    let radiusType2 = "&language=ko&rankby=distance&keyword="
    let search2 = "bank"
    let key2 = "&key="
    //activity indiactor
    lazy var indicator : UIActivityIndicatorView = {
        var indi = UIActivityIndicatorView()
        let transfrom = CGAffineTransform.init(scaleX: 2.5, y: 2.5)
        indi.transform = transfrom
        indi.startAnimating()
        indi.style = UIActivityIndicatorView.Style.whiteLarge
        indi.color = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        indi.translatesAutoresizingMaskIntoConstraints = false
        return indi
    }()

    let logoImage : UIImageView = {
           let logo = UIImageView()
           logo.translatesAutoresizingMaskIntoConstraints = false
           logo.image = #imageLiteral(resourceName: "logo")
           return logo
    }()
    
    override func loadView() {
        super.loadView()
        //현재 위치
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization() //권한 요청
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.startUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        //title을 정해준다
        title = "당신의 선택"
        //구글 place api를 사용하기 위해서 추가
        placesClient = GMSPlacesClient.shared()
        setup()
        startTimer()
    }
    
    //url에서 json데이터를 받아오는 함수
    func callURL(url:String,search : String){
        
        let browKey = "AIzaSyDyStsE4WHE1YLRVx9uYRFLjqZ3tlEmdrE"
        //한글 검색어도 사용할 수 있도록 함
        
        let lat : Double = (locationManager?.location?.coordinate.latitude)!
        let lng : Double = (locationManager?.location?.coordinate.longitude)!
        
        let addQuery2 = url2 + "\(lat)" + "," + "\(lng)" + radiusType2 + search2 + key2 + browKey
        let addQuery = url + "\(lat)" + "," + "\(lng)" + radiusType + search +  key + browKey
        
        let encoded = addQuery2.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        var request = URLRequest(url: URL(string: encoded!)!)
        request.httpMethod = "GET"                 //Naver 도서 API는 GET
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        //Task
        let task = session.dataTask(with: request) { (data, response, error) in
            //통신 성공
            if let data = data {
                self.json = JSON(data)
            }
            //통신 실패
            if let error = error {
                print(error.localizedDescription)
            }
        }
        print(self.json)
        task.resume()
    }
    
    //받아온 json데이터를 배열로 만들어 주는 함수
    func itemAppend(){
        for i in 0...(jsonCount ?? 6){
            item.append((self.json?["results"][i])!)
        }
    }
    
    //타이머를 작동시켜서 timeLimit()을 실행된다.
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeLimit), userInfo: nil, repeats: true)
    }
    //위치가 업데이트될때마다
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if (manager.location?.coordinate) != nil{
            callURL(url: self.url, search: self.search)
        }
    }
    //인터넷 오류 때문에 값이 안불러올때
    func errorAlert(style : UIAlertController.Style){
           let alert = UIAlertController(title: "연결 에러", message:"인터넷 연결을 확인해주세요", preferredStyle: .alert)
           let success = UIAlertAction(title: "확인", style: .default) { (action) in
               //success를 눌렀을 때 MapViewController로 이동하면서 데이터를 전해준다.
                self.navigationController?.popViewController(animated: true)
           }
           alert.addAction(success)
           self.present(alert, animated: true, completion: nil)
       }
    //alert창을 나오게 하는 함수
    func showAlert(style : UIAlertController.Style, result : String){
        let alert = UIAlertController(title: "모해의 추천!!!", message: result + "는 어때?", preferredStyle: .alert)
        let success = UIAlertAction(title: "너무 좋죠", style: .default) { (action) in
            //success를 눌렀을 때 MapViewController로 이동하면서 데이터를 전해준다.
            let view = MapViewController()
            if(self.locationManager != nil && (self.json != nil)  && self.jsonCount != nil ){
                view.defaultLocation = CLLocation(latitude: (self.locationManager?.location?.coordinate.latitude)!, longitude: (self.locationManager?.location?.coordinate.longitude)!)
                view.itemReady = self.item
                view.jsonCount = self.jsonCount
                self.navigationController?.pushViewController(view, animated: true)
            } else {
                self.errorAlert(style: .alert)
            }
        }
        let cancel = UIAlertAction(title: "시러요", style: .cancel){ (action) in
            self.navigationController?.popViewController(animated: true)
        }
        
        alert.addAction(success)
        alert.addAction(cancel)
        //alert함수를 화면에 보여준다.
        self.present(alert, animated: true, completion: nil)
    }
    //타이머가 2초 이하일때는 대기하다가 2초 이상이 되면 activity indicator를 멈추고 알림창을 보여준다.
    @objc func timeLimit(){
        if time == 0 {
            self.indicator.startAnimating()
            print("대기")
            time += 1
        } else if time == 1 {
            //json데이터의 객수를 구하고 데이터를 저장한다
            if json != nil {
                jsonCount = json?["results"].count
                    if jsonCount != nil {
                        itemAppend()
                    }
            }
            time += 1
        } else {
            //indicator를 멈추고 알러트함수를 호출하고 타이머를 멈춰준다.
            self.indicator.stopAnimating()
            showAlert(style: .alert, result: search)
            timer.invalidate()
            time = 0
        }
    }
    //오토레이아웃 설정해주기
    func setup(){
        view.addSubview(logoImage)
        logoImage.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(70)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(300)
            make.height.equalTo(150)
        }
        
        view.addSubview(indicator)
        indicator.snp.makeConstraints { (make) in
            make.center.equalTo(self.view.snp.center)
            make.width.equalTo(300)
            make.height.equalTo(300)
        }
    }
}

