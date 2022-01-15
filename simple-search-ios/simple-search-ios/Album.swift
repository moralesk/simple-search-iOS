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
    let cover_small: String
    let cover_medium: String
    let release_date: String
    let record_type: String
    let tracklist: String
    let explicit_lyrics: Bool
}
