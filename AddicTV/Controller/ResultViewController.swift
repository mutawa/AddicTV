//
//  ResultViewController.swift
//  AddicTV
//
//  Created by Ahmad Al-Mutawa on 07/07/2019.
//  Copyright © 2019 Ahmad Al-Mutawa. All rights reserved.
//

import UIKit
import CoreData


class ResultViewController: UIViewController {
    
    var context:NSManagedObjectContext {
        return DataController.shared.context
    }
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
        
        let fr:NSFetchRequest<Show> = Show.fetchRequest()
        let sd = NSSortDescriptor(key: "id", ascending: true)
        let p = NSPredicate(format: "id == \(show.id)")
        fr.predicate = p
        
        fr.sortDescriptors = [sd]
        
        if let result = try? context.fetch(fr) {
            if result.count == 0 {
                navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToMyShows))
                
            }
        }
        
        
        

        
    }
    override func viewDidAppear(_ animated: Bool) {
        if imageView?.image == nil {
            configureUI()
        }
    }
    
    @objc func addToMyShows() {
        let show = Show(context: context)
        show.id = Int64(self.show.id)
        show.name = self.show.name
        show.summary = self.show.summary
        show.photo = self.imageView?.image?.pngData()
        
        // move this to a separate method
        do {
            try context.save()
            navigationItem.rightBarButtonItem = nil
            
        } catch {
            
        }
        
        
        
        
        
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
