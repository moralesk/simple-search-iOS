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
    let pictureSmall: String
    let pictureMedium: String
    let pictureLarge: String
    let pictureXL: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case link
        case picture
        case pictureSmall = "picture_small"
        case pictureMedium = "picture_medium"
        case pictureLarge = "picture_big"
        case pictureXL = "picture_xl"
    }
}
