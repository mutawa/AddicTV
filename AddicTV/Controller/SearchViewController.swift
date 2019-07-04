//
//  SearchViewController.swift
//  AddicTV
//
//  Created by Ahmad Al-Mutawa on 04/07/2019.
//  Copyright © 2019 Ahmad Al-Mutawa. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    let searchController = UISearchController(searchResultsController: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            self.searchController.searchBar.placeholder = "Search any TV Show"
            
            self.navigationItem.hidesSearchBarWhenScrolling = false
            
        }
        
    }
        
    
    
   


}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        TVMazeAPI.shared.search(for: "prison break") { errorString in
            if errorString != nil {
                print(errorString!)
            }
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        cell.textLabel?.text = "\(indexPath)"
        
        return cell
    }
    
    
}

