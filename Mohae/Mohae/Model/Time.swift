//
//  Time.swift
//  Mohae
//
//  Created by 이주영 on 2019/11/05.
//  Copyright © 2019 권혁준. All rights reserved.
//

import Foundation

class Time: NSObject {
    var am: Int?
    var launch: Int?
    var pm: Int?
    var evening: Int?
    var night: Int?

    init(dictionary: [String: AnyObject]) {
        super.init()
        
        am = dictionary["am"] as? Int
        launch = dictionary["launch"] as? Int
        pm = dictionary["pm"] as? Int
        evening = dictionary["evening"] as? Int
        night = dictionary["night"] as? Int
    }
}
