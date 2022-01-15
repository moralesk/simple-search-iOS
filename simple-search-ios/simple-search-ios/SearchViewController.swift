//
//  SearchViewController.swift
//  simple-search-ios
//
//  Created by Kelly Morales on 1/12/22.
//

import UIKit

/// ViewController for a simple interface allowing users to search for and select artists
class SearchViewController: UIViewController {

    private let searchController: UISearchController = {
        let controller = UISearchController()
        controller.searchBar.placeholder = "Browse artists"
        return controller
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemGray6
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    /// The list of artists shown in the tableView
    private var artists: [Artist]?

    /// Class containing logic for search APIs
    var searchNetworkingProvider: SearchNetworkingProviding?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home" // TODO: get from localized strings

        // using default adaptive colors to support light and dark mode
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .systemGray

        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController

        setUpTableView()
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
            artists?.removeAll()
            tableView.reloadData()
        } else {
            DispatchQueue.global().async { [weak self] in
                self?.searchNetworkingProvider?.fetchArtist(searchTerm) { [weak self] result in
                    switch result {
                    case .success(let artists):
                        if artists.isEmpty {
                            // show empty state
                            print("empty")
                        } else {
                            self?.artists = artists
                        }
                    case .failure(let error):
                        // show error state
                        print(error)
                    }

                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let artistID = artists?[indexPath.row].id else {
            assertionFailure("Error: could not unwrap selected artist")
            return
        }

        DispatchQueue.global().async { [weak self] in
            self?.searchNetworkingProvider?.fetchAlbums(artistID) { [weak self] result in
                switch result {
                case .success(let albums):
                    // go to artist albums
                    print(albums)
                case .failure(let error):
                    // show error state
                    print(error)
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // no rows if there are no locally saved artists & nothing in the search bar, or either value is nil
        if (searchController.searchBar.text?.isEmpty ?? true) && (artists?.isEmpty ?? true) {
            return 0
        }

        // at least one row per artist or for an error state
        return artists?.count ?? 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "test")
        cell.textLabel?.text = artists?[indexPath.row].name
        return cell
    }
}

// MARK: - Private
private extension SearchViewController {

    func setUpTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        let topConstraint = NSLayoutConstraint(item: tableView,
                                               attribute: .top,
                                               relatedBy: .equal,
                                               toItem: view,
                                               attribute: .topMargin,
                                               multiplier: 1,
                                               constant: 0)

        let leadingConstraint = NSLayoutConstraint(item: tableView,
                                               attribute: .leading,
                                               relatedBy: .equal,
                                               toItem: view,
                                               attribute: .leading,
                                               multiplier: 1,
                                               constant: 0)

        let trailingConstraint = NSLayoutConstraint(item: tableView,
                                                    attribute: .trailing,
                                                    relatedBy: .equal,
                                                    toItem: view,
                                                    attribute: .trailing,
                                                    multiplier: 1,
                                                    constant: 0)

        let bottomConstraint = NSLayoutConstraint(item: tableView,
                                                  attribute: .bottom,
                                                  relatedBy: .equal,
                                                  toItem: view,
                                                  attribute: .bottom,
                                                  multiplier: 1,
                                                  constant: 0)

        NSLayoutConstraint.activate([
            topConstraint,
            leadingConstraint,
            trailingConstraint,
            bottomConstraint
        ])
    }
}
