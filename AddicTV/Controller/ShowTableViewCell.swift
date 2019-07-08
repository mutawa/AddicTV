//
//  ShowTableViewCell.swift
//  AddicTV
//
//  Created by Ahmad Al-Mutawa on 7/4/19.
//  Copyright © 2019 Ahmad Al-Mutawa. All rights reserved.
//

import UIKit



class ShowTableViewCell:UITableViewCell {
    
    @IBOutlet weak var thumbnailImage:UIImageView!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var subtitleLabel:UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    var show:Media! {
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
        
        
        // since we are dealing with an object that conforms to Media protocol,
        // we only need to see if we are dealing with a struct so that we may
        // ask the API to fetch the images. Otherwise, CoreData already has photo
        // data stored
        
        if show.requiresFetching {
            // double check, we may already have an image. There is no point wasting resources
            if show.thumbnailPhoto == nil {
                
                // take a note of what we are about to request (i.e, make a copy of the struct)
                // this copy will be useful when the API is finished loading an image. We will
                // check if the returned image is really the one we have been waiting for.
                // The user might have scrolled away, or the cell has been dequeued and its model
                // has changed. So we will ensure that we are updating the right cell
                let captured = show
                
                
                if let url = captured?.thumbnailUrl {
                    API.shared.getImage(urlString: url) { [weak self] data, error in
                        
                        guard error == nil else { return }
                        guard let data = data else { return }
                        
                        // check if the model is the same one as it was before the API call
                        guard captured?.showId == self?.show.showId else { return }
                        
                        // it is the same model. Update its thumbnail photo
                        self?.show.thumbnailPhoto = data
                        self?.thumbnailImage.image = UIImage(data: data)
                    }
                }
            } else {
                // no fetching. The imageData is already available
                self.thumbnailImage.image = UIImage(data: show.thumbnailPhoto!)
            }
        } else {
            // This is a CoreData object, no fetching required
            
            if let thumbData = self.show.thumbnailPhoto {
                
                self.imageView?.image = UIImage(data: thumbData)
            } else {
                thumbnailImage.image = UIImage(named: Constants.Show.placeholderImageName )
            }
        }
        
        
    }
}
