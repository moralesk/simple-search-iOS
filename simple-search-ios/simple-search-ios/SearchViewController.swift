//
//  SearchViewController.swift
//  simple-search-ios
//
//  Created by Kelly Morales on 1/12/22.
//

import UIKit

/// ViewController for a simple interface allowing users to search for and select artists
class SearchViewController: UIViewController {

    private let searchController = UISearchController()

    /// Class containing logic for search APIs
    var searchNetworkingProvider: SearchNetworkingProviding?

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

// MARK: - UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchTerm = searchController.searchBar.text else {
            assertionFailure("Error: unable to extract text from search bar.")
            return
        }

        if searchTerm.isEmpty {
            print("empty")
        } else {
            searchNetworkingProvider?.fetchArtist(searchTerm) { result in
                switch result {
                case .success(let artists):
                    print(artists)
                    if artists.isEmpty {
                        // show empty state
                    } else {
                        // populate table with artists
                    }
                case .failure(let error):
                    // show error state
                    print(error)
                }
            }
        }
    }
}
