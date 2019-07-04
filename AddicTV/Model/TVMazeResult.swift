//
//  TVMazeResult.swift
//  AddicTV
//
//  Created by Ahmad Al-Mutawa on 04/07/2019.
//  Copyright © 2019 Ahmad Al-Mutawa. All rights reserved.
//

import Foundation

struct TVMazeResult:Codable {
    let score:Float
    let show:[TVMazeShow]
    enum codingKeys:String,CodingKey {
        case score,show
    }
}


struct TVMazeShow:Codable {
    let id:Int
    let url:String
    let name:String
    let language:String
    //let genres:[String]
    //let images:[TVMazePhoto]?
    //let externals:[TVMazeExternal]
    enum codingKeys:String,CodingKey {
        case id,url,name,language  //,genres,images,externals
    }
    
}

struct TVMazeExternal:Codable {
    let tvrage:Int?
    let thetvdb:Int?
    let imdb:String?
    enum codingKeys: String, CodingKey {
        case tvrage,thetvdb,imdb
    }
}

struct TVMazePhoto:Codable {
    let medium:String?
    let original:String?
    enum codingKeys: String, CodingKey {
        case medium, original
    }
}
