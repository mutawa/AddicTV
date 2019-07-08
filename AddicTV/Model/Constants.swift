//
//  Constants.swift
//  AddicTV
//
//  Created by Ahmad Al-Mutawa on 08/07/2019.
//  Copyright © 2019 Ahmad Al-Mutawa. All rights reserved.
//

import UIKit

struct Constants {
    struct TVMaze {
        static let url = "https://api.tvmaze.com/"
    }
    struct Search {
        static let segueIdentifier = "search details"
        static let normalCellIdentifier = "cell"
        static let noResultCellIdentifier = "no result"
        static let defaultCellIdentifier = "placeholder"
        static let dataRowHeight:CGFloat = 80
        static let emptyRowHeight:CGFloat = 180
    }
    
    struct Favorites {
        static let defaultCellIdentifier = "placeholder"
        static let dataCellIdentifier = "cell"
        static let dataRowHeight:CGFloat = 80
        static let emptyRowHeight:CGFloat = 180
        static let segueIdentifier = "show favorite"
    }
    
    struct Show {
        static let placeholderImageName = "placeholder"
    }
}
