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
        
        // check if we have objects in the array (i.e: we have search results)
        if searchResults.count>0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Search.normalCellIdentifier) as? ShowTableViewCell
            cell?.show = searchResults[indexPath.row]
            return cell!
        } else {
            // we don't have any search restls
            
            // first check if the user was trying to search for something that does not exits
            
            if let searchText = searchController.searchBar.text, searchText.count > 0 {
            
                
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Search.noResultCellIdentifier)
                cell?.textLabel?.text = "Could not find any results for \"\(searchText)\""
                
                // it might be useful to check if there was an API error and
                // display that to the user
                
                if apiErrorMessage != nil {
                    // replace the [No Result] message with the error from the API
                    cell?.textLabel?.text = apiErrorMessage
                }
                return cell!
            } else {
                // the user was not searching for anything.
                // display the welcome label
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Search.defaultCellIdentifier)
                
                return cell!
            }
            
        }
        
        
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // If this is a normal data row, then return 80 points.
        // If else, then it is either a [No Result], [Error from API], or [Welcome]
        // In that case, return double the points
        
        return searchResults.count>0 ? Constants.Search.dataRowHeight : Constants.Search.emptyRowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // first, remove the selection
        tableView.deselectRow(at: indexPath, animated: true)
        
        // make sure the user didn't just tap the [welcome] or the [no results] cells
        guard searchResults.count > 0 else {  return }
        
        
        // extract the show object from the cell
        // since it might have been mutated by the cell, and if it is a struct
        // the copy mutated by the cell will not be present from the datasource array
        // but if it is a class, then this would work too
        // ps: mutated copy contains images pulled from the network
        // it would be a waste to pull them again when seguing to the next view controller
        let cell = tableView.cellForRow(at: indexPath) as! ShowTableViewCell
        
        
        performSegue(withIdentifier: Constants.Search.segueIdentifier, sender: cell.show)
        
    }
    
}

