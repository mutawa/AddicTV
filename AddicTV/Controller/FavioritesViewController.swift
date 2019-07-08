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
    var favorites = [Show]() {
        didSet {
            tableView.reloadData()
        }
        
    }

    
    @IBOutlet weak var tableView: UITableView!
    var context:NSManagedObjectContext {
        return DataController.shared.context
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(toggleEditingMode))
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        reload()
    }
    
    @objc func toggleEditingMode() {
        
        let item:UIBarButtonItem.SystemItem = (tableView.isEditing) ? .edit : .done
        
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: item, target: self, action: #selector(toggleEditingMode))
        
        tableView.setEditing(!tableView.isEditing, animated: true)
        
    }
    private func reload() {

//        if view.window != nil {

        let fr:NSFetchRequest<Show> = Show.fetchRequest()
        let sd = NSSortDescriptor(key: "name", ascending: true)
        
        fr.sortDescriptors = [sd]
        
        if let result = try? context.fetch(fr) {
            favorites = result
        }
        
        
//        }
    }
        
}

extension FavioritesViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("number of rows in section \(section) is \(favorites.count)")
        
        return max(favorites.count, 1)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return favorites.count>0 ? 80 : 160
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        
        if favorites.count == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "placeholder")
          
        } else {
        
            cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ShowTableViewCell
            
            if let tvcell = cell as? ShowTableViewCell {
                tvcell.show = favorites[indexPath.row]
            }
            
            
        }
        return cell!
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
        
        
        performSegue(withIdentifier: "show favorite", sender: favorites[indexPath.row])
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "show favorite" else { print("wrong segue"); return }
        guard sender is TVSeries else { print("sender is not a tv series object"); return }
        guard let svc = segue.destination as? ShowViewController else {print("wrong destination"); return}
        
        let show = sender as! TVSeries
        svc.show = show
        
        
        
    }
    
}
