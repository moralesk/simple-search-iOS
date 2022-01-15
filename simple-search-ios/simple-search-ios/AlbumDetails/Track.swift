//
//  Track.swift
//  simple-search-ios
//
//  Created by Kelly Morales on 1/15/22.
//

import Foundation

/// Contains an array of `Track`s found in an `Album`
class Tracklist: Decodable {
    let tracks: [Track]

    enum CodingKeys: String, CodingKey {
        case tracks = "data"
    }
}

/// Details about a track in an `Album`
class Track: Decodable {
    let id: Int
    let title: String
    let duration: Int
    let trackPosition: Int
    let isExplicit: Bool
    let artist: TrackArtist

    enum CodingKeys: String, CodingKey {
        case id, title, duration
        case trackPosition = "track_position"
        case isExplicit = "explicit_lyrics"
        case artist
    }
}

/**
 * Should be the same as the `Artist` of the `Album` that this `Track` is contained in,
 * but this provides an easier way to access the name and allows it to be different if
 * the API needs it to be.
 */
class TrackArtist: Decodable {
    let name: String
}
