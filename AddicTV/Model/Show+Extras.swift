//
//  Show+Extras.swift
//  AddicTV
//
//  Created by Ahmad Al-Mutawa on 08/07/2019.
//  Copyright © 2019 Ahmad Al-Mutawa. All rights reserved.
//

import Foundation

// Making CoreData object conform to Media protocol

extension Show:Media {
    var showId: Int { return Int(id) }
    var title: String? { return name }
    var synopses: String? { return self.summary }
    var genresList: String? { return genres }
    var date: String? { return releaseDate }
    var requiresFetching:Bool { return false }
    
    var thumbnailPhoto: Data? {
        get {
            return thumbnail
        }
        set {
            thumbnail = newValue
        }
    }
    
    var detailPhoto: Data? {
        get {
            return photo
        }
        set {
            photo = newValue
        }
    }
    
    // urls are only applicable for structs coming from the API
    var posterUrl: String? { return nil }
    var thumbnailUrl: String? { return nil }
    
   
}
