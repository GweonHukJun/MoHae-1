//
//  SubSurvey.swift
//  Mohae
//
//  Created by 이주영 on 28/08/2019.
//  Copyright © 2019 이주영. All rights reserved.
//

import Foundation

class SubSurvey: NSObject {
    var id: String?
    var question: String?
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        
        id = dictionary["id"] as? String
        question = dictionary["question"] as? String
    }
}
