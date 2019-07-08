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
    var searchResults = [TVMazeShow]()
    
    var context:NSManagedObjectContext {
        return DataController.shared.context
    }
    
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("will appear")
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("will dis-appear")
        self.searchController.searchBar.resignFirstResponder()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("did appear")
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier=="search details" else { return }
        guard let dvc = segue.destination as? ResultViewController else { return }
        guard let detailShow = sender as? TVMazeShow else { fatalError("could not get details show") }
        
        dvc.show = detailShow
        
        
    }
    
    
    
   


}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        TVMazeAPI.shared.search(for: searchText) { shows,errorString in
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TVCell else { return TVCell() }
        
        cell.show = searchResults[indexPath.row]
        
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! TVCell
        
        
        performSegue(withIdentifier: "search details", sender: cell.show)
        
    }
    
}

