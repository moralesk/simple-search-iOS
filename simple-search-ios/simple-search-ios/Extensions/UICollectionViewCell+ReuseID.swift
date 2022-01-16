//
//  UICollectionViewCell+ReuseID.swift
//  simple-search-ios
//
//  Created by Kelly Morales on 1/16/22.
//

import UIKit

extension UICollectionViewCell {

    static var reuseID: String {
        String(describing: self)
    }
}
