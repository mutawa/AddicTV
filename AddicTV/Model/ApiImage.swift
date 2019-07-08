//
//  ApiImage.swift
//  AddicTV
//
//  Created by Ahmad Al-Mutawa on 08/07/2019.
//  Copyright © 2019 Ahmad Al-Mutawa. All rights reserved.
//

import Foundation

struct ApiImage:Codable {
    let medium:String
    let original:String
    
    var mediumPhoto:Data?
    var originalPhoto:Data?
    
    enum codingKeys: String, CodingKey {
        case medium, original
    }
}
