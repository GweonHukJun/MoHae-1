//
//  NumberOfPeople.swift
//  Mohae
//
//  Created by 이주영 on 2019/11/05.
//  Copyright © 2019 권혁준. All rights reserved.
//

import Foundation

class NumberOfPeople: NSObject {
    var oneToTwo: Int?
    var threeToFive: Int?
    var moreThanSix: Int?
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        
        oneToTwo = dictionary["1 ~ 2"] as? Int
        threeToFive = dictionary["3 ~ 5"] as? Int
        moreThanSix = dictionary["moreThan6"] as? Int
    }
}
