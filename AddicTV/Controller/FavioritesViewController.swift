//
//  FavoritesViewController.swift
//  AddicTV
//
//  Created by Ahmad Al-Mutawa on 07/07/2019.
//  Copyright © 2019 Ahmad Al-Mutawa. All rights reserved.
//

import UIKit
import CoreData


class FavioritesViewController : UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var context:NSManagedObjectContext {
        return DataController.shared.context
    }
    
    var favorites = [Show]() {
        didSet {
            tableView.reloadData()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(toggleEditingMode))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // only do the expensive work when we know the view is about to appear
        loadMyFavorites()
    }
    
    @objc func toggleEditingMode() {
        // change the button from [edit] to [done] or vice versa
        let item:UIBarButtonItem.SystemItem = (tableView.isEditing) ? .edit : .done
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: item, target: self, action: #selector(toggleEditingMode))
        
        // toggle tableView edit mode
        tableView.setEditing(!tableView.isEditing, animated: true)
        
    }
    
    
    private func loadMyFavorites() {

        let fetchRequest:NSFetchRequest<Show> = Show.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let result = try? context.fetch(fetchRequest) {
            favorites = result
        }

    }
        
}

extension FavioritesViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return max(favorites.count, 1)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return favorites.count>0 ? Constants.Favorites.dataRowHeight : Constants.Favorites.emptyRowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        
        // check if we have objects in the array
        if favorites.count == 0 {
            // we dont.. display the [Welcome] cell
            cell = tableView.dequeueReusableCell(withIdentifier: Constants.Favorites.defaultCellIdentifier)
          
        } else {
            // we do.. then display the normal data cell
            
            cell = tableView.dequeueReusableCell(withIdentifier: Constants.Favorites.dataCellIdentifier) as? ShowTableViewCell
            
            // assign the cells model so that it may start its own UI thing
            if let tvcell = cell as? ShowTableViewCell {
                tvcell.show = favorites[indexPath.row]
            }

        }
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return favorites.count>0
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard favorites.count>0 else { return }
        switch(editingStyle) {
        case .delete:
            //tableView.beginUpdates()
            let toRemove = favorites.remove(at: indexPath.row)
            context.delete(toRemove)
            try? context.save()
            //print("deleting row at [\(indexPath.section)][\(indexPath.row)]")
            //tableView.deleteRows(at: [indexPath], with: .top)
            //tableView.endUpdates()
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if favorites.count>0 {
            performSegue(withIdentifier: Constants.Favorites.segueIdentifier, sender: favorites[indexPath.row])
        }
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // make sure everything is in order
        guard segue.identifier == Constants.Favorites.segueIdentifier else { fatalError("Invalid segue identifier") }
        guard sender is Media else { fatalError("invalid object passed to sender") }
        guard let svc = segue.destination as? ShowViewController else { fatalError("destination controller is invalid") }
        
        let show = sender as! Media
        svc.show = show
        
        
        
    }
    
}
