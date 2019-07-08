//
//  ShowTableViewCell.swift
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

extension ApiShow:TVSeries {
    var thumbnailPhoto: Data? {
        get {
            return image?.mediumPhoto
        }
        set {
            //print("setting tv struct thumbnail photo \(id)")
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

class ShowTableViewCell:UITableViewCell {
    
    @IBOutlet weak var thumbnailImage:UIImageView!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var subtitleLabel:UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    var show:TVSeries! {
        didSet {
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
        thumbnailImage.image = nil
        
        
        
        if show.requiresFetching {
            //print("\(show.title ?? "this show is") a struct requires fetching")
            if show.thumbnailPhoto == nil {
                //print("\(show.title ?? "this show is") attempting fetching")
                let captured = show
                if let url = captured?.thumbnailUrl {
                    API.shared.getImage(urlString: url) { [weak self] data, error in
                        
                        guard error == nil else { return }
                        guard let data = data else { return }
                        guard captured?.showId == self?.show.showId else {
                            //print("\(captured?.title ?? "this show is") too late. different than \(self?.show.title ?? "was old show title")");
                            return }
                        self?.show.thumbnailPhoto = data
                        self?.thumbnailImage.image = UIImage(data: data)
                    }
                }
            } else {
                //print("\(self.show.title ?? "this show is ") but no need to fetch. Already have the image data")
                self.thumbnailImage.image = UIImage(data: show.thumbnailPhoto!)
            }
        } else {
            
            //print("\(self.show.title ?? "this show is") CoreData no fetching required")
            if let thumbData = self.show.thumbnailPhoto {
                //print("\(self.show.title ?? "this show is ") has thumbnail data")
                self.imageView?.image = UIImage(data: thumbData)
            } else {
                thumbnailImage.image = UIImage(named: "placeholder")
                //print("\(self.show.title ?? "this show is") missing thumbnail photo data")
                
            }
        }
        
        
    }
}

extension String {
    var toSecureHttp : String {
        return self.replacingOccurrences(of: "http://", with: "https://", options: .literal, range: nil)
    }
}
