//
//  ApiShow.swift
//  AddicTV
//
//  Created by Ahmad Al-Mutawa on 08/07/2019.
//  Copyright © 2019 Ahmad Al-Mutawa. All rights reserved.
//

import Foundation


struct ApiShow:Codable {
    let id:Int
    let url:String
    let name:String
    let language:String
    let genres:[String]
    var image:ApiImage?

    let premiered:String?
    let summary:String
    enum codingKeys:String,CodingKey {
        case id,url,name,language,genres,images, premiered, summary
    }
    
    
}
