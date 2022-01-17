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

    private var contentContainerView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .fillProportionally
        view.spacing = Constants.contentSpacing
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var resultImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray6
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private var artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.artistNameFont
        label.textAlignment = .left
        return label
    }()

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
        static let imageViewWidth = 75.0
        static let imageViewHeight = 60.0
        static let artistNameFont = UIFont.systemFont(ofSize: 18.0,
                                                      weight: .medium)
        static let contentSpacing = 12.0
        static let contentInsets = UIEdgeInsets(top: 4.0,
                                                left: 8.0,
                                                bottom: 4.0,
                                                right: 8.0)
    }

    func setUpView() {
        setUpContentContainerView()
        setUpImageView()

        if resultImageView.superview == nil {
            contentContainerView.addArrangedSubview(resultImageView)
        }

        if artistNameLabel.superview == nil {
            contentContainerView.addArrangedSubview(artistNameLabel)
        }
    }

    func setUpContentContainerView() {
        if contentContainerView.superview == nil {
            contentView.addSubview(contentContainerView)
        }

        let topConstraint = NSLayoutConstraint(item: contentContainerView,
                                               attribute: .top,
                                               relatedBy: .equal,
                                               toItem: contentView,
                                               attribute: .top,
                                               multiplier: 1,
                                               constant: Constants.contentInsets.top)

        let leadingConstraint = NSLayoutConstraint(item: contentContainerView,
                                                   attribute: .leading,
                                                   relatedBy: .equal,
                                                   toItem: contentView,
                                                   attribute: .leading,
                                                   multiplier: 1,
                                                   constant: Constants.contentInsets.left)

        let trailingConstraint = NSLayoutConstraint(item: contentContainerView,
                                                    attribute: .trailing,
                                                    relatedBy: .equal,
                                                    toItem: contentView,
                                                    attribute: .trailing,
                                                    multiplier: 1,
                                                    constant: -Constants.contentInsets.right)

        let bottomConstraint = NSLayoutConstraint(item: contentContainerView,
                                                  attribute: .bottom,
                                                  relatedBy: .equal,
                                                  toItem: contentView,
                                                  attribute: .bottom,
                                                  multiplier: 1,
                                                  constant: -Constants.contentInsets.bottom)

        NSLayoutConstraint.activate([
            topConstraint,
            leadingConstraint,
            trailingConstraint,
            bottomConstraint
        ])
    }

    func setUpImageView() {
        resultImageView.heightAnchor.constraint(equalToConstant: Constants.imageViewHeight).isActive = true
        resultImageView.widthAnchor.constraint(equalToConstant: Constants.imageViewWidth).isActive = true
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
