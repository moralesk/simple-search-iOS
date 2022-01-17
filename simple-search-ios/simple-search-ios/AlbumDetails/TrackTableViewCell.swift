//
//  TrackTableViewCell.swift
//  simple-search-ios
//
//  Created by Kelly Morales on 1/16/22.
//

import UIKit

class TrackTableViewCell: UITableViewCell {

    private let contentContainerView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .fillProportionally
        view.spacing = Constants.contentSpacing
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    /// Used to keep track number label consistent and right aligned when in the `contentContainerView`
    private let numberContainerView = UIView()
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.numberFont
        label.textAlignment = .right
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let titleAndArtistContainerView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.nameFont
        label.textAlignment = .left
        return label
    }()

    private let artistLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.artistFont
        label.textAlignment = .left
        return label
    }()

    private let durationLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.durationFont
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.textAlignment = .right
        return label
    }()

    /// Provides functionality for formatting the track duration into a time string
    var trackDurationProvider: TrackDurationProviding?

    /// Sets up view given artist info
    func bind(track: Track) {
        setUpView()

        numberLabel.text = "\(track.trackPosition)."
        durationLabel.text = trackDurationProvider?.formattedTrackDuration(seconds: track.duration)
        titleLabel.text = track.title
        artistLabel.text = track.artist.name
    }
}

// MARK: - Private
private extension TrackTableViewCell {

    struct Constants {
        static let numberFont = UIFont.systemFont(ofSize: 20.0,
                                                  weight: .medium)
        static let nameFont = UIFont.systemFont(ofSize: 18.0,
                                                weight: .medium)
        static let artistFont = UIFont.systemFont(ofSize: 14.0,
                                                  weight: .thin)
        static let durationFont = UIFont.systemFont(ofSize: 16.0,
                                                    weight: .medium)
        static let contentInsets = UIEdgeInsets(top: 8.0,
                                                left: 8.0,
                                                bottom: 8.0,
                                                right: 12.0)
        static let contentSpacing = 12.0
        static let numberContainerHeight = 30.0
        static let numberContainerWidth = 30.0
    }

    func setUpView() {
        selectionStyle = .none

        setUpContentContainerView()
        setUpNumberContainerView()

        if numberContainerView.superview == nil {
            contentContainerView.addArrangedSubview(numberContainerView)
        }

        if titleAndArtistContainerView.superview == nil {
            contentContainerView.addArrangedSubview(titleAndArtistContainerView)
        }

        if durationLabel.superview == nil {
            contentContainerView.addArrangedSubview(durationLabel)
        }

        if titleLabel.superview == nil {
            titleAndArtistContainerView.addArrangedSubview(titleLabel)
        }

        if artistLabel.superview == nil {
            titleAndArtistContainerView.addArrangedSubview(artistLabel)
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

    func setUpNumberContainerView() {
        if numberLabel.superview == nil {
            numberContainerView.addSubview(numberLabel)
        }

        numberContainerView.heightAnchor.constraint(equalToConstant: Constants.numberContainerHeight).isActive = true
        numberContainerView.widthAnchor.constraint(equalToConstant: Constants.numberContainerWidth).isActive = true

        let trailingConstraint = NSLayoutConstraint(item: numberLabel,
                                                    attribute: .trailing,
                                                    relatedBy: .equal,
                                                    toItem: numberContainerView,
                                                    attribute: .trailing,
                                                    multiplier: 1,
                                                    constant: 0)

        let centerYConstraint = NSLayoutConstraint(item: numberLabel,
                                                   attribute: .centerY,
                                                   relatedBy: .equal,
                                                   toItem: numberContainerView,
                                                   attribute: .centerY,
                                                   multiplier: 1,
                                                   constant: 0)

        NSLayoutConstraint.activate([
            trailingConstraint,
            centerYConstraint
        ])
    }
}
