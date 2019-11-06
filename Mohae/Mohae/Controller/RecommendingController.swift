//
//  RecommendingController.swift
//  Mohae
//
//  Created by 이주영 on 2019/11/04.
//  Copyright © 2019 권혁준. All rights reserved.
//

import UIKit
import Firebase
import SnapKit

class RecommendingController: UIViewController {
    var ref: DatabaseReference!
    var categorys = [Category]()
    var couples = [Couple]()
    var feelings = [Feeling]()
    var money = [Money]()
    var numberOfPeople = [NumberOfPeople]()
    var personality = [Personality]()
    var time = [Time]()
    var weather = [Weather]()
    let search = "백화점"
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        loadDB()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem:.add,target: self, action:#selector(moveDate))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @objc func moveDate(){
        let view = AgreeViewController()
        view.search = self.search
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    func loadDB() {
        print("satrt load DB")
        ref = Database.database().reference().child("DataForAnalysis3")
        
        ref.child("category").observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            self.categorys.append(Category(dictionary: dictionary))
            print("categorys added => \(String(describing: self.categorys[self.categorys.count-1].value))")
        }
        
        ref.child("couple").observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            self.couples.append(Couple(dictionary: dictionary))
            print("couples added => \(String(describing: self.couples[self.couples.count-1].value))")
        }
        
        ref.child("feeling").observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            self.feelings.append(Feeling(dictionary: dictionary))
            print("feelings added => \(String(describing: self.feelings[self.feelings.count-1].happy))")
        }
        
        ref.child("money").observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            self.money.append(Money(dictionary: dictionary))
            print("money added => \(String(describing: self.money[self.money.count-1].free))")
        }
        
        ref.child("numberOfPeople").observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            self.numberOfPeople.append(NumberOfPeople(dictionary: dictionary))
            print("numberOfPeople added => \(String(describing: self.numberOfPeople[self.numberOfPeople.count-1].oneToTwo))")
        }
        
        ref.child("personality").observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            self.personality.append(Personality(dictionary: dictionary))
            print("personality added => \(String(describing: self.personality[self.personality.count-1].outsider))")
        }
        
        ref.child("time").observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            self.time.append(Time(dictionary: dictionary))
            print("time added => \(String(describing: self.time[self.time.count-1].am))")
        }
        
        print("time added => \(time)")
        
        ref.child("weather").observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            self.weather.append(Weather(dictionary: dictionary))
            print("weather added => \(String(describing: self.weather[self.weather.count-1].sunny))")
        }
    }
}

