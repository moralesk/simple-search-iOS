//
//  DeezerAPI.swift
//  simple-search-ios
//
//  Created by Kelly Morales on 1/15/22.
//

import Foundation

/// Constant values for the Deezer APIs used in the app
struct DeezerAPI {
    static let baseURL = "https://api.deezer.com"

    struct Endpoint {
        static let search = "/search"
        static let artist = "/artist"
        static let artistAlbums = "/albums"
        static let albumTracks = "/tracks"
        static let albumDetails = "/album"
    }
}
