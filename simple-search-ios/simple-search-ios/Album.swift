//
//  Album.swift
//  simple-search-ios
//
//  Created by Kelly Morales on 1/14/22.
//

import Foundation

struct Albums: Decodable {
    let albumsArray: [Album]

    enum CodingKeys: String, CodingKey {
        case albumsArray = "data"
    }
}

struct Album: Decodable {
    let id: Int
    let title: String
    let link: String
    let cover: String
    let coverSmall: String
    let coverMedium: String
    let releaseDate: String
    let type: String
    let isExplicit: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case link
        case cover
        case coverSmall = "cover_small"
        case coverMedium = "cover_medium"
        case releaseDate = "release_date"
        case type = "record_type"
        case isExplicit = "explicit_lyrics"
    }
}
