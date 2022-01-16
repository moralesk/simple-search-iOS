//
//  SearchResultTableViewCell.swift
//  simple-search-ios
//
//  Created by Kelly Morales on 1/15/22.
//

import UIKit

/// Cell used for displaying an artist preview when searching for an artist
class SearchResultTableViewCell: UITableViewCell {

    /// Contains logic for efficiently fetching UIImages to display in the cell
    var imageNetworkingProvider: ImageNetworkingProviding?

    private var resultImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray6
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private var artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.artistNameFontSize,
                                       weight: .medium)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setUpView()
    }

    override func updateConstraints() {
        super.updateConstraints()
        setUpView()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        resultImageView.image = nil
    }

    /// Sets up view given artist info
    func bind(artist: Artist) {
        setUpView()

        if let imageURL = URL(string: artist.picture) {
            setImage(imageURL: imageURL)
        }

        artistNameLabel.text = artist.name
    }
}

// MARK: - Private
private extension SearchResultTableViewCell {

    struct Constants {
        static let imageViewTopBottomPadding = 12.0
        static let imageViewLeadingPadding = 8.0
        static let imageViewWidth = 70.0
        static let imageViewHeight = 50.0
        static let artistNameLeftPadding = 12.0
        static let artistNameRightPadding = 8.0
        static let artistNameFontSize = 18.0
    }

    func setUpView() {
        setUpImageView()
        setUpArtistNameLabel()
    }

    func setUpImageView() {
        if resultImageView.superview == nil {
            contentView.addSubview(resultImageView)
        }

        let topConstraint = NSLayoutConstraint(item: resultImageView,
                                               attribute: .top,
                                               relatedBy: .equal,
                                               toItem: contentView,
                                               attribute: .top,
                                               multiplier: 1,
                                               constant: Constants.imageViewTopBottomPadding)

        let leadingConstraint = NSLayoutConstraint(item: resultImageView,
                                                   attribute: .leading,
                                                   relatedBy: .equal,
                                                   toItem: contentView,
                                                   attribute: .leading,
                                                   multiplier: 1,
                                                   constant: Constants.imageViewLeadingPadding)

        let widthConstraint = NSLayoutConstraint(item: resultImageView,
                                                 attribute: .width,
                                                 relatedBy: .equal,
                                                 toItem: contentView,
                                                 attribute: .width,
                                                 multiplier: 0,
                                                 constant: Constants.imageViewWidth)

        let heightConstraint = NSLayoutConstraint(item: resultImageView,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: contentView,
                                                  attribute: .height,
                                                  multiplier: 0,
                                                  constant: Constants.imageViewHeight)

        let bottomConstraint = NSLayoutConstraint(item: resultImageView,
                                                  attribute: .bottom,
                                                  relatedBy: .equal,
                                                  toItem: contentView,
                                                  attribute: .bottom,
                                                  multiplier: 1,
                                                  constant: Constants.imageViewTopBottomPadding)

        NSLayoutConstraint.activate([
            topConstraint,
            leadingConstraint,
            widthConstraint,
            heightConstraint,
            bottomConstraint
        ])
    }

    func setUpArtistNameLabel() {
        if artistNameLabel.superview == nil {
            contentView.addSubview(artistNameLabel)
        }

        let centerYConstraint = NSLayoutConstraint(item: artistNameLabel,
                                                   attribute: .centerY,
                                                   relatedBy: .equal,
                                                   toItem: contentView,
                                                   attribute: .centerY,
                                                   multiplier: 1,
                                                   constant: 0)

        let leadingConstraint = NSLayoutConstraint(item: artistNameLabel,
                                                   attribute: .leading,
                                                   relatedBy: .equal,
                                                   toItem: resultImageView,
                                                   attribute: .trailing,
                                                   multiplier: 1,
                                                   constant: Constants.artistNameLeftPadding)

        let trailingConstraint = NSLayoutConstraint(item: artistNameLabel,
                                                    attribute: .trailing,
                                                    relatedBy: .equal,
                                                    toItem: contentView,
                                                    attribute: .trailing,
                                                    multiplier: 1,
                                                    constant: -Constants.artistNameRightPadding)

        NSLayoutConstraint.activate([
            centerYConstraint,
            leadingConstraint,
            trailingConstraint
        ])
    }

    func setImage(imageURL: URL) {
        DispatchQueue.global().async { [weak self] in
            self?.imageNetworkingProvider?.fetchImage(from: imageURL) { result in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        self?.resultImageView.image = image
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
