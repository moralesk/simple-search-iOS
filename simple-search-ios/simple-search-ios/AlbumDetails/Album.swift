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
    let coverMedium: String

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case coverMedium = "cover_medium"
    }
}
