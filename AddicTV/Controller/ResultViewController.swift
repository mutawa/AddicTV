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
    
    var show:TVSeries! {
        didSet {
            imageView?.image = nil
            //configureUI()
        }
        
    }
    
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var summaryTextField: UITextView!
    
    
    override func viewDidLoad() {
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let fr:NSFetchRequest<Show> = Show.fetchRequest()
        let sd = NSSortDescriptor(key: "id", ascending: true)
        let p = NSPredicate(format: "id == \(show.showId)")
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
        let newShow = Show(context: context)
        newShow.id = Int64(self.show.showId)
        newShow.name = self.show.title
        newShow.summary = self.show.synopses
        newShow.thumbnail = self.show.thumbnailPhoto
        newShow.photo = self.show.detailPhoto
        
        newShow.genres = self.show.genresList
        newShow.releaseDate = self.show.date
        
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
            summaryTextField.text = show.synopses?.htmlToString
            
            if let imgData = show.detailPhoto {
                self.imageView?.image = UIImage(data: imgData)
                return
            }
            
            
            
            if show.requiresFetching, let urlString = show.posterUrl {
                TVMazeAPI.shared.getImage(urlString: urlString) { [weak self] data,error in
                    guard error==nil else { self?.imageView?.image = UIImage(named: "placeholder");  return }
                    guard let data=data else { return }
                    
                    self?.show.detailPhoto = data
                    
                    self?.imageView?.image = UIImage(data: data)
                }
            } else {
                if let imgData = show.detailPhoto {
                    self.imageView?.image = UIImage(data: imgData)
                }
                
            }
            
            
           
        }
       

    }
    
}


extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard
            let data = self.data(using: .utf8)
            else { return nil }
        do {
            return try NSAttributedString(data: data, options: [
                NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
                NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue
                ], documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            return  nil
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
