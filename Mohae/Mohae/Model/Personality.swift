//
//  Personality.swift
//  Mohae
//
//  Created by 이주영 on 2019/11/05.
//  Copyright © 2019 권혁준. All rights reserved.
//

import Foundation

class Personality: NSObject {
    var emotional: Int?
    var outsider: Int?
    var sensory: Int?
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        
        emotional = dictionary["emotional"] as? Int
        outsider = dictionary["outsider"] as? Int
        sensory = dictionary["sensory"] as? Int
    }
}
