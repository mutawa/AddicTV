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
    var apiErrorMessage:String?
    
    var context:NSManagedObjectContext {
        return DataController.shared.context
    }
    
    @IBOutlet weak var spinner:UIActivityIndicatorView!
    @IBOutlet weak var tableView:UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        
    }
    
    func configureUI() {
        title = "Search TV Shows"
        
        navigationController?.navigationBar.prefersLargeTitles = false
        definesPresentationContext = true
        
        // Add the searchBar at the top of the view controller
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false  // prevent screen from dimming while text is being entered
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == Constants.Search.segueIdentifier else { return }
        guard let dvc = segue.destination as? ShowViewController else { return }
        guard let detailShow = sender as? ApiShow else { fatalError("Invalid parameters passed to sender") }
        
        dvc.show = detailShow
        
        
    }
    
    
    
   


}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // display the activity indicator
        spinner.startAnimating()
        
        // call the API
        API.shared.search(for: searchText) { shows,errorString in
            // stop the activity inidcator
            self.spinner.stopAnimating()
            
            self.apiErrorMessage = errorString
            if errorString != nil { self.tableView.reloadData(); return }
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
            if let searchText = searchController.searchBar.text, searchText.count > 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "no result")
                cell?.textLabel?.text = "Could not find any results for \"\(searchText)\""
                if apiErrorMessage != nil {
                    cell?.textLabel?.text = apiErrorMessage

                }
                return cell!
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "placeholder")
                //cell?.textLabel?.text = "Start by searching for a show"
                return cell!
            }
            
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

