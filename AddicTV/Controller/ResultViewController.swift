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
    var show:TVMazeShow! {
        didSet {
            imageView?.image = nil
            configureUI()
        }
    }
    
    @IBOutlet weak var imageView: UIImageView?
    
    
    
    @IBOutlet weak var summaryTextField: UITextView!
    
    
    override func viewDidLoad() {
        configureUI()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToMyShows))
    }
    override func viewDidAppear(_ animated: Bool) {
        if imageView?.image == nil {
            configureUI()
        }
    }
    
    @objc func addToMyShows() {
        
    }
    func configureUI() {
        
        // only start fetching when the view is visible to the user
        if view.window != nil {
            if let urlString = show.image?.urlMedium {
                TVMazeAPI.shared.getImage(urlString: urlString) { [weak self] data,error in
                    guard error==nil else { self?.imageView?.image = UIImage(named: "placeholder");  return }
                    guard let data=data else { return }
                    
                    self?.imageView?.image = UIImage(data: data)
                }
            }
            summaryTextField.text = show.summary
           
        }
       

    }
    
}
