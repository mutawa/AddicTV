//
//  ApiResult.swift
//  AddicTV
//
//  Created by Ahmad Al-Mutawa on 08/07/2019.
//  Copyright © 2019 Ahmad Al-Mutawa. All rights reserved.
//


import Foundation


struct ApiResult:Codable {
    
    let score:Float
    let show:ApiShow
    enum codingKeys:String,CodingKey {
        case score,show
    }
    
    
    
    
}
