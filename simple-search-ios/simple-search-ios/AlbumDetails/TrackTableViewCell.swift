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

    private let numberContainerView: UIView = {
        let view = UIView()
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        return view
    }()

    private let numberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.numberFontSize,
                                       weight: .medium)
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
        label.font = UIFont.systemFont(ofSize: Constants.nameFontSize,
                                       weight: .medium)
        label.textAlignment = .left
        return label
    }()

    private let artistLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.artistFontSize,
                                       weight: .thin)
        label.textAlignment = .left
        return label
    }()

    private let durationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.durationFontSize,
                                       weight: .medium)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.textAlignment = .right
        return label
    }()

    /// Provides functionality for formatting the track duration into a time string
    var trackDurationProvider: TrackDurationProviding?

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
        static let numberFontSize = 20.0
        static let nameFontSize = 18.0
        static let artistFontSize = 14.0
        static let durationFontSize = 16.0
        static let contentInsets = UIEdgeInsets(top: 12.0,
                                                left: 12.0,
                                                bottom: 12.0,
                                                right: 12.0)
        static let contentSpacing = 12.0
        static let numberLabelInsets = UIEdgeInsets(top: 12,
                                                    left: 12,
                                                    bottom: 12,
                                                    right: 0)
    }

    func setUpView() {
        selectionStyle = .none

        if contentContainerView.superview == nil {
            contentView.addSubview(contentContainerView)
        }

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

        let height = NSLayoutConstraint(item: numberLabel,
                                        attribute: .height,
                                        relatedBy: .equal,
                                        toItem: numberContainerView,
                                        attribute: .height,
                                        multiplier: 0,
                                        constant: 30)

        let width = NSLayoutConstraint(item: numberLabel,
                                       attribute: .width,
                                       relatedBy: .equal,
                                       toItem: numberContainerView,
                                       attribute: .width,
                                       multiplier: 0,
                                       constant: 30)

        let centerXConstraint = NSLayoutConstraint(item: numberLabel,
                                                   attribute: .centerX,
                                                   relatedBy: .equal,
                                                   toItem: numberContainerView,
                                                   attribute: .centerX,
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
            height,
            width,
            centerXConstraint,
            centerYConstraint
        ])
    }
}
