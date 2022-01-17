//
//  SearchResultHeaderView.swift
//  simple-search-ios
//
//  Created by Kelly Morales on 1/17/22.
//

import UIKit

/// A simple view with a title used to mark a section header
class SearchResultHeaderView: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.titleLabelFontSize,
                                       weight: .thin)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    /// Sets up the title's constraints and text
    func bind(title: String) {
        setUpView()
        titleLabel.text = title
    }
}

// MARK: - Private
private extension SearchResultHeaderView {

    struct Constants {
        static let titleLabelFontSize = 22.0
        static let titleLabelInsets = UIEdgeInsets(top: 14.0,
                                                   left: 8.0,
                                                   bottom: 14.0,
                                                   right: 8.0)
    }

    func setUpView() {
        backgroundColor = .systemBackground
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            .init(item: titleLabel,
                  attribute: .top,
                  relatedBy: .equal,
                  toItem: self,
                  attribute: .top,
                  multiplier: 1,
                  constant: Constants.titleLabelInsets.top),

            .init(item: titleLabel,
                  attribute: .leading,
                  relatedBy: .equal,
                  toItem: self,
                  attribute: .leading,
                  multiplier: 1,
                  constant: Constants.titleLabelInsets.left),

            .init(item: titleLabel,
                  attribute: .trailing,
                  relatedBy: .equal,
                  toItem: self,
                  attribute: .trailing,
                  multiplier: 1,
                  constant: -Constants.titleLabelInsets.right),

            .init(item: titleLabel,
                  attribute: .bottom,
                  relatedBy: .equal,
                  toItem: self,
                  attribute: .bottom,
                  multiplier: 1,
                  constant: -Constants.titleLabelInsets.bottom)
        ])
    }
}
