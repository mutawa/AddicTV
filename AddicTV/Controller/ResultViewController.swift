//
//  ResultViewController.swift
//  AddicTV
//
//  Created by Ahmad Al-Mutawa on 07/07/2019.
//  Copyright © 2019 Ahmad Al-Mutawa. All rights reserved.
//

import UIKit
import WebKit

class ResultViewController: UIViewController {
    var show:TVMazeShow!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var labelView: UILabel!
    
    @IBOutlet weak var textField: UITextView!
    
    
    override func viewDidLoad() {
        //configureUI()
    }
    
    func configureUI() {
        imageView.image = UIImage(named: "placeholder")
        if let urlString = show.image?.urlMedium {
            TVMazeAPI.shared.getImage(urlString: urlString) { [weak self] data,error in
                guard error==nil else { return }
                guard let data=data else { return }
                
                self?.imageView.image = UIImage(data: data)
            }
        }
        textField.text = show.summary
        
        //labelView.text = show.summary
    }
    
}
