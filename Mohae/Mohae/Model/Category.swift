//
//  Category.swift
//  Mohae
//
//  Created by 이주영 on 2019/11/05.
//  Copyright © 2019 권혁준. All rights reserved.
//

import Foundation

class Category: NSObject {
    var value: String?
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        
        value = dictionary["value"] as? String
    }
}
