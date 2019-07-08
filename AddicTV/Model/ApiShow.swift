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


extension ApiShow:Media {
    
    var showId: Int { return id }
    var title: String? { return name }
    var synopses: String? { return summary }
    
    // geners are returned from API in the form of an Array of strings
    var genresList: String? { return genres.joined(separator: ", ") }
    var date: String? { return premiered }
    var requiresFetching:Bool { return true }
    
    // these Data? properties are not obtained from the initial search API call
    // these will be used to hold the data temporarly until the user decides to
    // add the media to his/her favorites list
    var thumbnailPhoto: Data? {
        get {
            return image?.mediumPhoto
        }
        set {
            image?.mediumPhoto = newValue
        }
    }
    
    var detailPhoto: Data? {
        get {
            return image?.originalPhoto
        }
        set {
            image?.originalPhoto = newValue
        }
    }
    
    // make sure all url from API are secure
    var posterUrl: String? { return image?.original.toSecureHttp}
    var thumbnailUrl: String? { return image?.medium.toSecureHttp }
    
    
}
