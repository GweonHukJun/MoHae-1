//
//  Weather.swift
//  Mohae
//
//  Created by 이주영 on 2019/11/05.
//  Copyright © 2019 권혁준. All rights reserved.
//

import Foundation

class Weather: NSObject {
    var sunny: Int?
    var rainy: Int?
    var cloudy: Int?
    var snow: Int?
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        
        sunny = dictionary["sunny"] as? Int
        rainy = dictionary["rainy"] as? Int
        cloudy = dictionary["cloudy"] as? Int
        snow = dictionary["snow"] as? Int
    }
}
