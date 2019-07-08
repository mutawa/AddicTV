//
//  TVCell.swift
//  AddicTV
//
//  Created by Ahmad Al-Mutawa on 7/4/19.
//  Copyright © 2019 Ahmad Al-Mutawa. All rights reserved.
//

import UIKit

protocol TVSeries {
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

extension Show:TVSeries {
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
    
    var posterUrl: String? {
        return nil
    }
    

    
    var showId: Int { return Int(id) }
    var title: String? { return name }
    var synopses: String? { return self.summary }
    var thumbnailUrl: String? { return nil }
    var genresList: String? { return genres }
    var date: String? { return releaseDate }
    var requiresFetching:Bool { return false }
}

extension TVMazeShow:TVSeries {
    var thumbnailPhoto: Data? {
        get {
            return nil
        }
        set {
            
        }
    }
    
    var detailPhoto: Data? {
        get {
            return nil
        }
        set {
            
        }
    }
    
    var posterUrl: String? {
        return image?.original.toSecureHttp
    }
    
        
    var showId: Int { return id }
    var title: String? { return name }
    var synopses: String? { return summary }
    var thumbnailUrl: String? { return image?.medium.toSecureHttp }
    var genresList: String? { return genres.joined(separator: ", ") }
    var date: String? { return premiered }
    var requiresFetching:Bool { return true }
}

class TVCell:UITableViewCell {
    
    @IBOutlet weak var thumbnailImage:UIImageView!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var subtitleLabel:UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    var show:TVSeries! {
        didSet{
            configureUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.accessoryType = .disclosureIndicator
    }
    
    private func configureUI() {
        titleLabel.text = show.title
        subtitleLabel.text = show.genresList
        yearLabel.text = show.date
        thumbnailImage.image = UIImage(named: "placeholder")
        if show.requiresFetching {
            let captured = show
            if let url = captured?.thumbnailUrl {
                TVMazeAPI.shared.getImage(urlString: url) { [weak self] data, error in
                    
                    guard error == nil else { return }
                    guard let data = data else { return }
                    guard captured?.showId == self?.show.showId else { print("too late. different"); return }
                    self?.thumbnailImage.image = UIImage(data: data)
                }
            }
        } else {
            
        }
        
    }
}

extension String {
    var toSecureHttp : String {
        return self.replacingOccurrences(of: "http://", with: "https://", options: .literal, range: nil)
    }
}
