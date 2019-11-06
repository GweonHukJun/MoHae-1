//
//  Couple.swift
//  Mohae
//
//  Created by 이주영 on 2019/11/05.
//  Copyright © 2019 권혁준. All rights reserved.
//

import Foundation

class Couple: NSObject {
    var value: Int?
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        
        value = dictionary["value"] as? Int
    }
}
