//
//  AlbumListViewController.swift
//  simple-search-ios
//
//  Created by Kelly Morales on 1/15/22.
//

import UIKit

/**
 * ViewController for displaying an artist's albums in a UICollectionView
 */
class AlbumListViewController: UIViewController {
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    /// The album's artist, used for UI
    var artistName: String?
    
    /// The list of albums displayed in the collectionView
    var albums: [Album]?
    
    /// Contains logic for album info APIs
    var networkingProvider: AlbumNetworkingProviding?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        setUpCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = artistName
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        title = ""
    }
}

// MARK: - UICollectionViewDataSource
extension AlbumListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        albums?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.reuseID,
                                                            for: indexPath) as? AlbumCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        guard let album = albums?[indexPath.item] else {
            return UICollectionViewCell()
        }
        
        cell.imageNetworkingProvider = ImageNetworkingProvider()
        cell.bind(album: album, artistName: artistName ?? "")
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension AlbumListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let album = albums?[indexPath.item] else {
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            self?.networkingProvider?.fetchAlbumTracklist(albumID: album.id) { result in
                switch result {
                case .success(let tracks):
                    self?.navigateToTracklist(tracks: tracks, albumName: album.title)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: Constants.cellPadding,
            left: Constants.cellPadding,
            bottom: Constants.cellPadding,
            right: Constants.cellPadding)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension AlbumListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // TODO: size for view instead of calculating here
        // create a square cell size that is half of the full screen width
        // with the left and right cell paddings subtracted
        let portraitOrientationWidth = UIScreen.main.bounds.width / 2 - (Constants.cellPadding * 2)
        let labelHeight = 65.0
        return CGSize(width: portraitOrientationWidth, height: portraitOrientationWidth + labelHeight)
    }
}

// MARK: - Private
private extension AlbumListViewController {
    
    struct Constants {
        static let cellPadding: CGFloat = 8
    }
    
    func navigateToTracklist(tracks: [Track], albumName: String) {
        let viewController = TracklistViewController()
        viewController.albumName = albumName
        viewController.tracks = tracks
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func setUpCollectionView() {
        if collectionView.superview == nil {
            view.addSubview(collectionView)
        }
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(AlbumCollectionViewCell.self,
                                forCellWithReuseIdentifier: AlbumCollectionViewCell.reuseID)
        
        let topConstraint = NSLayoutConstraint(item: collectionView,
                                               attribute: .top,
                                               relatedBy: .equal,
                                               toItem: view,
                                               attribute: .top,
                                               multiplier: 1,
                                               constant: view.safeAreaInsets.top)
        
        let leadingConstraint = NSLayoutConstraint(item: collectionView,
                                                   attribute: .leading,
                                                   relatedBy: .equal,
                                                   toItem: view,
                                                   attribute: .leading,
                                                   multiplier: 1,
                                                   constant: 0)
        
        let trailingConstraint = NSLayoutConstraint(item: collectionView,
                                                    attribute: .trailing,
                                                    relatedBy: .equal,
                                                    toItem: view,
                                                    attribute: .trailing,
                                                    multiplier: 1,
                                                    constant: 0)
        
        let bottomConstraint = NSLayoutConstraint(item: collectionView,
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
