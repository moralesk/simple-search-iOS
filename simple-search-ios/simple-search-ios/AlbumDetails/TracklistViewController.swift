//
//  TracklistViewController.swift
//  simple-search-ios
//
//  Created by Kelly Morales on 1/15/22.
//

import UIKit

/**
 * ViewController for displaying an album's list of songs
 */
class TracklistViewController: UIViewController {

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemGray6
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    /// The name of the artist of this album
    var artist: String?

    /// The name of the album for the given tracklist
    var album: String?

    /// The list of tracks displayed in the tableView
    var tracks: [Track]?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let album = album {
            let navTitleView = NavigationDetailTitleView()
            navTitleView.bind(title: album, subtitle: artist)
            navigationItem.titleView = navTitleView
        }

        setUpTableView()
    }
}

// MARK: - UITableViewDataSource
extension TracklistViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrackTableViewCell.reuseID, for: indexPath) as? TrackTableViewCell else {
            return UITableViewCell()
        }

        guard let track = tracks?[indexPath.row] else {
            return UITableViewCell()
        }

        cell.trackDurationProvider = TrackDurationProvider()
        cell.bind(track: track)
        return cell
    }
}

// MARK: - Private
private extension TracklistViewController {

    func setUpTableView() {
        if tableView.superview == nil {
            view.addSubview(tableView)
        }

        tableView.register(TrackTableViewCell.self,
                           forCellReuseIdentifier: TrackTableViewCell.reuseID)
        tableView.dataSource = self

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
