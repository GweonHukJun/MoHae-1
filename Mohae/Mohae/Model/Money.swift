//
//  Money.swift
//  Mohae
//
//  Created by 이주영 on 2019/11/05.
//  Copyright © 2019 권혁준. All rights reserved.
//

import Foundation

class Money: NSObject {
    var free: Int?
    var oneToFive: Int?
    var sixToTen: Int?
    var moreThanTen: Int?
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        
        free = dictionary["free"] as? Int
        oneToFive = dictionary["1 ~ 5"] as? Int
        sixToTen = dictionary["6 ~ 10"] as? Int
        moreThanTen = dictionary["moreThan10"] as? Int
    }
}
