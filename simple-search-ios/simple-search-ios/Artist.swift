//
//  Artist.swift
//  simple-search-ios
//
//  Created by Kelly Morales on 1/14/22.
//

import Foundation

struct Artists: Decodable {
    let artistArray: [Artist]

    enum CodingKeys: String, CodingKey {
        case artistArray = "data"
    }
}

class Artist: Decodable {
    let id: Int
    let name: String
    let link: String
    let picture: String
    let picture_small: String
    let picture_medium: String
    let picture_big: String
    let picture_xl: String
}
