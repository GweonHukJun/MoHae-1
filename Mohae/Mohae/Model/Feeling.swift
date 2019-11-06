//
//  Feeling.swift
//  Mohae
//
//  Created by 이주영 on 2019/11/05.
//  Copyright © 2019 권혁준. All rights reserved.
//

import Foundation

class Feeling: NSObject {
    var happy: Int?
    var sad: Int?
    var calm: Int?
    var exciting: Int?
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        
        happy = dictionary["happy"] as? Int
        sad = dictionary["sad"] as? Int
        calm = dictionary["calm"] as? Int
        exciting = dictionary["exciting"] as? Int
    }
}
