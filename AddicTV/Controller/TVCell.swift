//
//  TVCell.swift
//  AddicTV
//
//  Created by Ahmad Al-Mutawa on 7/4/19.
//  Copyright © 2019 Ahmad Al-Mutawa. All rights reserved.
//

import UIKit

class TVCell:UITableViewCell {
    
    @IBOutlet weak var thumbnailImage:UIImageView!
    @IBOutlet weak var titleLabel:UILabel!
    var show:TVMazeShow! {
        didSet{
            configureUI()
        }
    }
    
    private func configureUI() {
        titleLabel.text = show.name
        thumbnailImage.image = UIImage(named: "placeholder")
        if let url = show.image?.urlMedium {
            TVMazeAPI.shared.getImage(urlString: url) { [weak self] data, error in
                guard error == nil else { return }
                guard let data = data else { return }
                self?.thumbnailImage.image = UIImage(data: data)
            }
        }
    }
}
