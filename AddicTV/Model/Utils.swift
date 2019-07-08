//
//  Utils.swift
//  AddicTV
//
//  Created by Ahmad Al-Mutawa on 08/07/2019.
//  Copyright © 2019 Ahmad Al-Mutawa. All rights reserved.
//

import Foundation



extension String {
    // some links returned by the API are not secure.
    // this extension, ensures that the link always contains https:// at the begining
    var toSecureHttp : String {
        return self.replacingOccurrences(of: "http://", with: "https://", options: .literal, range: nil)
    }
}


// this protocol will reduce code written for Structs and Classes of CoreData
// by making sure both [Structs] and [CoreData objects] conform to Media protocol,
// we can deal with only one entity in the code, regardless of what type of entity it is

protocol Media {
    var showId:Int {get}
    var title:String? {get}
    var synopses:String? {get}
    var thumbnailUrl:String? {get}
    var posterUrl:String? {get}
    var genresList:String? {get}
    var date:String? {get}
    var thumbnailPhoto:Data? {get set}
    var detailPhoto:Data? {get set}
    var requiresFetching:Bool {get}
    
}
