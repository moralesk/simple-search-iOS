//
//  UITableViewCell+ReuseID.swift
//  simple-search-ios
//
//  Created by Kelly Morales on 1/15/22.
//

import UIKit

extension UITableViewCell {

    static var reuseID: String {
        String(describing: self)
    }
}
