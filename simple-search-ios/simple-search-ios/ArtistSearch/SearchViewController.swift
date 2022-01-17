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
        
        // using default adaptive colors to support light and dark mode
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .systemGray
        
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        
        setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // set title when view will appear so leaving and returning to the screen shows the title
        title = "Home" // TODO: get from localized strings
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // change title so back button only has arrow on pushed screens
        title = ""
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
                            // TODO: show empty state
                            self?.artists = artists
                        } else {
                            self?.artists = artists
                        }
                    case .failure(let error):
                        // TODO: show error state
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
        guard let artist = artists?[indexPath.row] else {
            assertionFailure("Error: could not unwrap selected artist")
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            self?.searchNetworkingProvider?.fetchAlbums(artist.id) { [weak self] result in
                switch result {
                case .success(let albums):
                    if albums.isEmpty {
                        // TODO: show error.
                        // Don't send user to see album list if there are no albums.
                    } else {
                        self?.navigateToAlbums(artist: artist.name, albums: albums)
                    }
                case .failure(let error):
                    // TODO: show error state
                    assertionFailure(error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = SearchResultHeaderView()
        headerView.bind(title: "Artists")
        return headerView
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        // display no rows if there are no locally saved artists & nothing
        // in the search bar, or if either value is nil
        if (searchController.searchBar.text?.isEmpty ?? true) && (artists?.isEmpty ?? true) {
            return 0
        }

        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // at least one row per artist or for an error state
        return artists?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.reuseID, for: indexPath) as? SearchResultTableViewCell else {
            assertionFailure("Error: could not dequeue SearchResultTableViewCell for indexPath \(indexPath)")
            return UITableViewCell()
        }
        
        guard let artist = artists?[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.imageNetworkingProvider = ImageNetworkingProvider()
        cell.bind(artist: artist)
        return cell
    }
}

// MARK: - Private
private extension SearchViewController {
    
    func navigateToAlbums(artist: String, albums: [Album]) {
        let viewController = AlbumListViewController()
        viewController.albums = albums
        viewController.artistName = artist
        viewController.networkingProvider = AlbumNetworkingProvider()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func setUpTableView() {
        if tableView.superview == nil {
            view.addSubview(tableView)
        }
        
        tableView.register(
            SearchResultTableViewCell.self,
            forCellReuseIdentifier: SearchResultTableViewCell.reuseID)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let topConstraint = NSLayoutConstraint(item: tableView,
                                               attribute: .top,
                                               relatedBy: .equal,
                                               toItem: view,
                                               attribute: .top,
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
