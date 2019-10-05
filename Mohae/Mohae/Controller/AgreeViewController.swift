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

class AgreeViewController: UIViewController, CLLocationManagerDelegate {

    var json : JSON?
    var placesClient : GMSPlacesClient!
    var zoomLevel : Float = 15.0
    var locationManager:CLLocationManager?
 
    let defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)
    
    var delegate : MapViewController?
    
    let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location="
    let radiusType = "&language=ko&rankby=distance&type="
    let search = "restaurant"
    let key = "&key="
    
    lazy var button: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(agree), for: .touchUpInside)
        return btn
    }()
    
    override func loadView() {
        super.loadView()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization() //권한 요청
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.startUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        placesClient = GMSPlacesClient.shared()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem:.add,target: self, action:#selector(agree(sender:)))
        
        view.addSubview(button)
    }
    
    func callURL(url:String,search : String){
        
        let browKey = "AIzaSyDyStsE4WHE1YLRVx9uYRFLjqZ3tlEmdrE"
        //한글 검색어도 사용할 수 있도록 함
        
        let lat : Double = (locationManager?.location?.coordinate.latitude)!
        let lng : Double = (locationManager?.location?.coordinate.longitude)!
        
        let addQuery = url + "\(lat)" + "," + "\(lng)" + radiusType + search +  key + browKey
        print(addQuery)
        
        let encoded = addQuery.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
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
            print(self.json ?? "오류가 일어나서 데이터가 안들어갔네용^^")
            //통신 실패
            if let error = error {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //위치가 업데이트될때마다
        if let coor = manager.location?.coordinate{
            print("latitude" + String(coor.latitude) + "/ longitude" + String(coor.longitude))
            callURL(url: self.url, search: self.search)
        }
    }
    
    @objc func agree(sender:UIButton)
    {
        let view = MapViewController()
        view.defaultLocation = CLLocation(latitude: (locationManager?.location?.coordinate.latitude)!, longitude: (locationManager?.location?.coordinate.longitude)!)
        view.json = self.json
        self.navigationController?.pushViewController(view, animated: true)
    }
}

