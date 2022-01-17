//
//  NavigationDetailTitleView.swift
//  simple-search-ios
//
//  Created by Kelly Morales on 1/17/22.
//

import UIKit

/// A view to be displayed as a navigation bar title view.
/// Contains a title and a subtitle.
class NavigationDetailTitleView: UIView {

    private let containerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.titleFont
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.subtitleFont
        return label
    }()

    /// Sets up the view and sets the title and subtitle text
    func bind(title: String, subtitle: String?) {
        setUpView()
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
}

// MARK: - Private
private extension NavigationDetailTitleView {

    struct Constants {
        static let titleFont = UIFont.systemFont(ofSize: 16,
                                                 weight: .semibold)
        static let subtitleFont = UIFont.systemFont(ofSize: 14,
                                                    weight: .thin)
    }

    func setUpView() {
        addSubview(containerView)
        NSLayoutConstraint.activate([
            .init(item: containerView,
                  attribute: .top,
                  relatedBy: .equal,
                  toItem: self,
                  attribute: .top,
                  multiplier: 1,
                  constant: 0),
            .init(item: containerView,
                  attribute: .leading,
                  relatedBy: .equal,
                  toItem: self,
                  attribute: .leading,
                  multiplier: 1,
                  constant: 0),
            .init(item: containerView,
                  attribute: .trailing,
                  relatedBy: .equal,
                  toItem: self,
                  attribute: .trailing,
                  multiplier: 1,
                  constant: 0),
            .init(item: containerView,
                  attribute: .bottom,
                  relatedBy: .equal,
                  toItem: self,
                  attribute: .bottom,
                  multiplier: 1,
                  constant: 0),
        ])

        if titleLabel.superview == nil {
            containerView.addArrangedSubview(titleLabel)
        }

        if subtitleLabel.superview == nil {
            containerView.addArrangedSubview(subtitleLabel)
        }
    }
}
