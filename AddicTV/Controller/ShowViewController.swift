//
//  ShowViewController
//  AddicTV
//
//  Created by Ahmad Al-Mutawa on 07/07/2019.
//  Copyright © 2019 Ahmad Al-Mutawa. All rights reserved.
//

import UIKit
import CoreData


class ShowViewController: UIViewController {
    
    var context:NSManagedObjectContext {
        return DataController.shared.context
    }
    
    var show:Media! {
        didSet {
            imageView?.image = nil

        }
        
    }
    
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var summaryTextField: UITextView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        configureUI()
    }
    
    private func checkIfShowIsInMyFavorites() {
        
        let fr:NSFetchRequest<Show> = Show.fetchRequest()
        let sd = NSSortDescriptor(key: "id", ascending: true)
        let p = NSPredicate(format: "id == \(show.showId)")
        fr.predicate = p
        
        fr.sortDescriptors = [sd]
        
        if let result = try? context.fetch(fr) {
            if result.count == 0 {
//                navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks , target: self, action: #selector(addToMyShows))
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "☆", style: .plain, target: self, action: #selector(addToMyShows))
                
                
            } else {
                showAlreadyFavoredButton()
            }
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
        
        
        do {
            try context.save()
            
            showAlreadyFavoredButton()
            
            
        } catch {
            
        }
        
        
        
        
        
    }
    
    func showAlreadyFavoredButton() {
        let button = UIBarButtonItem(title: "★", style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = button
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            button.isEnabled = false
        }
        
        
    }
    
    func configureUI() {
        
        
        // only start fetching when the view is visible to the user
        if imageView?.image == nil {
            summaryTextField.text = show.synopses?.htmlToString
            title = show.title
            
            if let imgData = show.detailPhoto {
                self.imageView?.image = UIImage(data: imgData)
                return
            }
            
            
            
            if show.requiresFetching, let urlString = show.posterUrl {
                
                // we are populating the view from the API
                
                spinner.startAnimating()
                API.shared.getImage(urlString: urlString) { [weak self] data,error in
                    self?.spinner.stopAnimating()
                    
                    guard error==nil else { self?.imageView?.image = UIImage(named: Constants.Show.placeholderImageName);  return }
                    guard let data=data else { return }
                    
                    self?.show.detailPhoto = data
                    self?.imageView?.image = UIImage(data: data)
                    self?.checkIfShowIsInMyFavorites()
                    
                }
            } else {
                // incase we are populating the view from CoreData
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
