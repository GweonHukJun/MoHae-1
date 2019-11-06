//
//  DataForAnalysis.swift
//  Mohae
//
//  Created by 이주영 on 2019/11/04.
//  Copyright © 2019 권혁준. All rights reserved.
//

import Foundation

class DataForAnalysis: NSObject {
    var categoryValue: String?
    
    var coupleValue: Int?
    
    var calm: Int?
    var happy: Int?
    var sad: Int?
    var exciting: Int?
    
    var free: Int?
    var oneToFive: Int?
    var sixToTen: Int?
    var moreThanTen: Int?
    
    var onetToTwo: Int?
    var threeToFive: Int?
    var moreThanSix: Int?
    
    var emotional: Int?
    var outsider: Int?
    var sensory: Int?
    
    var am: Int?
    var launch: Int?
    var pm: Int?
    var evening: Int?
    var night: Int?
    
    var sunny: Int?
    var cloudy: Int?
    var rainy: Int?
    var snow: Int?
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        
        categoryValue = dictionary["categoryValue"] as? String
        
        coupleValue = dictionary["coupleValue"] as? Int
        
        happy = dictionary["happy"] as? Int
        calm = dictionary["calm"] as? Int
        sad = dictionary["sad"] as? Int
        exciting = dictionary["exciting"] as? Int
        
        free = dictionary["free"] as? Int
        oneToFive = dictionary["1 ~ 5"] as? Int
        sixToTen = dictionary["6 ~ 10"] as? Int
        moreThanTen = dictionary["moreThan10"] as? Int
        
        onetToTwo = dictionary["1 ~ 2"] as? Int
        threeToFive = dictionary["3 ~ 5"] as? Int
        moreThanSix = dictionary["moreThan6"] as? Int
        
        emotional = dictionary["emotional"] as? Int
        outsider = dictionary["outsider"] as? Int
        sensory = dictionary["sensory"] as? Int
        
        am = dictionary["am"] as? Int
        launch = dictionary["launch"] as? Int
        pm = dictionary["pm"] as? Int
        evening = dictionary["evening"] as? Int
        night = dictionary["night"] as? Int
        
        sunny = dictionary["sunny"] as? Int
        cloudy = dictionary["cloudy"] as? Int
        rainy = dictionary["rainy"] as? Int
        snow = dictionary["snow"] as? Int
    }
}
