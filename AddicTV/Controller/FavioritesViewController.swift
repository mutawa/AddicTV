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
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        reload()
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
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TVCell else { return UITableViewCell() }
        
        cell.show = favorites[indexPath.row]
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        performSegue(withIdentifier: "show favorite", sender: favorites[indexPath.row])
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "show favorite" else { print("wrong segue"); return }
        guard sender is TVSeries else { print("sender is not a tv series object"); return }
        guard let svc = segue.destination as? ResultViewController else {print("wrong destination"); return}
        
        let show = sender as! TVSeries
        svc.show = show
        
        
        
    }
    
}
