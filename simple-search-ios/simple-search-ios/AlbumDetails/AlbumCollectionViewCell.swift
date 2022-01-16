//
//  AlbumCollectionViewCell.swift
//  simple-search-ios
//
//  Created by Kelly Morales on 1/16/22.
//

import UIKit

/// Displays an album cover, title, and artist name
class AlbumCollectionViewCell: UICollectionViewCell {

    private var albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private var albumTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.albumTitleFontSize,
                                       weight: .medium)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.artistNameFontSize,
                                       weight: .thin)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    /// Contains logic for efficiently fetching UIImages to display in the cell
    var imageNetworkingProvider: ImageNetworkingProviding?

    override func prepareForReuse() {
        super.prepareForReuse()
        albumImageView.image = nil
    }

    /// Sets up view with the given album and artist name
    func bind(album: Album, artistName: String) {
        setUpView()

        if let imageURL = URL(string: album.cover) {
            setImage(imageURL: imageURL)
        }
        albumTitleLabel.text = album.title
        artistNameLabel.text = artistName
    }
}

// MARK: - Private
private extension AlbumCollectionViewCell {

    struct Constants {
        static let imageViewTopPadding = 8.0
        static let imageViewLeadingTrailingPadding = 0.0
        static let albumTitleLeftRightPadding = 8.0
        static let albumTitleTopPadding = 8.0
        static let albumTitleFontSize = 16.0
        static let artistNameFontSize = 14.0
        static let artistNameTopPadding = 4.0
        static let artistNameBottomPadding = 12.0
    }

    func setUpView() {
        setUpImageView()
        setUpAlbumTitleLabel()
        setUpArtistNameLabel()
    }

    func setUpImageView() {
        if albumImageView.superview == nil {
            contentView.addSubview(albumImageView)
        }

        let topConstraint = NSLayoutConstraint(item: albumImageView,
                                               attribute: .top,
                                               relatedBy: .equal,
                                               toItem: contentView,
                                               attribute: .top,
                                               multiplier: 1,
                                               constant: Constants.imageViewTopPadding)

        let leadingConstraint = NSLayoutConstraint(item: albumImageView,
                                                   attribute: .leading,
                                                   relatedBy: .equal,
                                                   toItem: contentView,
                                                   attribute: .leading,
                                                   multiplier: 1,
                                                   constant: Constants.imageViewLeadingTrailingPadding)

        let trailingConstraint = NSLayoutConstraint(item: albumImageView,
                                                 attribute: .trailing,
                                                 relatedBy: .equal,
                                                 toItem: contentView,
                                                 attribute: .trailing,
                                                 multiplier: 1,
                                                 constant: -Constants.imageViewLeadingTrailingPadding)

        let heightConstraints = NSLayoutConstraint(item: albumImageView,
                                                   attribute: .height,
                                                   relatedBy: .equal,
                                                   toItem: contentView,
                                                   attribute: .width,
                                                   multiplier: 1,
                                                   constant: 0)

        NSLayoutConstraint.activate([
            topConstraint,
            leadingConstraint,
            trailingConstraint,
            heightConstraints
        ])
    }

    func setUpAlbumTitleLabel() {
        if albumTitleLabel.superview == nil {
            contentView.addSubview(albumTitleLabel)
        }

        let topConstraint = NSLayoutConstraint(item: albumTitleLabel,
                                                   attribute: .top,
                                                   relatedBy: .equal,
                                                   toItem: albumImageView,
                                                   attribute: .bottom,
                                                   multiplier: 1,
                                               constant: Constants.albumTitleTopPadding)

        let leadingConstraint = NSLayoutConstraint(item: albumTitleLabel,
                                                   attribute: .leading,
                                                   relatedBy: .equal,
                                                   toItem: contentView,
                                                   attribute: .leading,
                                                   multiplier: 1,
                                                   constant: Constants.albumTitleLeftRightPadding)

        let trailingConstraint = NSLayoutConstraint(item: albumTitleLabel,
                                                    attribute: .trailing,
                                                    relatedBy: .equal,
                                                    toItem: contentView,
                                                    attribute: .trailing,
                                                    multiplier: 1,
                                                    constant: -Constants.albumTitleLeftRightPadding)

        NSLayoutConstraint.activate([
            topConstraint,
            leadingConstraint,
            trailingConstraint
        ])
    }

    func setUpArtistNameLabel() {
        if artistNameLabel.superview == nil {
            contentView.addSubview(artistNameLabel)
        }

        let topConstraint = NSLayoutConstraint(item: artistNameLabel,
                                                   attribute: .top,
                                                   relatedBy: .equal,
                                                   toItem: albumTitleLabel,
                                                   attribute: .bottom,
                                                   multiplier: 1,
                                               constant: Constants.artistNameTopPadding)

        let leadingConstraint = NSLayoutConstraint(item: artistNameLabel,
                                                   attribute: .leading,
                                                   relatedBy: .equal,
                                                   toItem: contentView,
                                                   attribute: .leading,
                                                   multiplier: 1,
                                                   constant: Constants.albumTitleLeftRightPadding)

        let trailingConstraint = NSLayoutConstraint(item: artistNameLabel,
                                                    attribute: .trailing,
                                                    relatedBy: .equal,
                                                    toItem: contentView,
                                                    attribute: .trailing,
                                                    multiplier: 1,
                                                    constant: -Constants.albumTitleLeftRightPadding)

        let bottomConstraint = NSLayoutConstraint(item: artistNameLabel,
                                                    attribute: .bottom,
                                                    relatedBy: .lessThanOrEqual,
                                                    toItem: contentView,
                                                    attribute: .bottom,
                                                    multiplier: 1,
                                                    constant: Constants.artistNameBottomPadding)

        NSLayoutConstraint.activate([
            topConstraint,
            leadingConstraint,
            trailingConstraint,
            bottomConstraint
        ])
    }

    func setImage(imageURL: URL) {
        DispatchQueue.global().async { [weak self] in
            self?.imageNetworkingProvider?.fetchImage(from: imageURL) { result in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        self?.albumImageView.image = image
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
