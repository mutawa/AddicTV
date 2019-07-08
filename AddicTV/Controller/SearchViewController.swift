//
//  SearchViewController.swift
//  AddicTV
//
//  Created by Ahmad Al-Mutawa on 04/07/2019.
//  Copyright © 2019 Ahmad Al-Mutawa. All rights reserved.
//

import UIKit
import CoreData

class SearchViewController: UIViewController {
    var searchResults = [ApiShow]()
    
    var context:NSManagedObjectContext {
        return DataController.shared.context
    }
    
    @IBOutlet weak var spinner:UIActivityIndicatorView!
    @IBOutlet weak var tableView:UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        definesPresentationContext = true
        
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
     
        
        
        
//        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
//            self.searchController.searchBar.placeholder = "Search any TV Show"
//            self.searchController.searchBar.becomeFirstResponder()
//
//
//
//        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier=="search details" else { return }
        guard let dvc = segue.destination as? ShowViewController else { return }
        guard let detailShow = sender as? ApiShow else { fatalError("could not get details show") }
        
        dvc.show = detailShow
        
        
    }
    
    
    
   


}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        spinner.startAnimating()
        API.shared.search(for: searchText) { shows,errorString in
            self.spinner.stopAnimating()
            if errorString != nil {
                print(errorString!)
            }
            guard let shows=shows else { return }
            self.searchResults = shows
            self.tableView.reloadData()
            
            if shows.count > 0 {
                self.navigationItem.hidesSearchBarWhenScrolling = true
            }
        }
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        
        

        searchBar.resignFirstResponder()
        searchBar.endEditing(true)
        return true
    }
    
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(searchResults.count, 1)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if searchResults.count>0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ShowTableViewCell
            cell?.show = searchResults[indexPath.row]
            return cell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "placeholder")
            //cell?.textLabel?.text = "Start by searching for a show"
            return cell!
        }
        
        
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return searchResults.count>0 ? 80 : 160
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! ShowTableViewCell
        
        
        performSegue(withIdentifier: "search details", sender: cell.show)
        
    }
    
}

