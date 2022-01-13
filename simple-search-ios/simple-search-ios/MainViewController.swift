//
//  MainViewController.swift
//  simple-search-ios
//
//  Created by Kelly Morales on 1/12/22.
//

import UIKit

class MainViewController: UIViewController {

    private let searchController = UISearchController()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home" // TODO: get from localized strings

        // using default adaptive colors to support light and dark mode
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .systemGray

        searchController.searchBar.placeholder = "Browse artists"
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }
}

extension MainViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        let searchTerm = searchController.searchBar.text
        print(searchTerm)
    }
}
