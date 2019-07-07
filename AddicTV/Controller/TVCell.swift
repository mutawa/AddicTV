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
    @IBOutlet weak var subtitleLabel:UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    var show:TVMazeShow! {
        didSet{
            configureUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.accessoryType = .disclosureIndicator
    }
    
    private func configureUI() {
        titleLabel.text = show.name
        subtitleLabel.text = show.genres.joined(separator: ", ")
        yearLabel.text = show.premiered
        thumbnailImage.image = UIImage(named: "placeholder")
        let captured = show
        if let url = captured?.image?.urlMedium {
            TVMazeAPI.shared.getImage(urlString: url) { [weak self] data, error in
                
                guard error == nil else { return }
                guard let data = data else { return }
                guard captured?.id == self?.show.id else { print("different"); return }
                self?.thumbnailImage.image = UIImage(data: data)
            }
        }
    }
}
