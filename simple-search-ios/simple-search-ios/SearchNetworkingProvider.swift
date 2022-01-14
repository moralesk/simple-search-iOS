//
//  SearchNetworkingProvider.swift
//  simple-search-ios
//
//  Created by Kelly Morales on 1/13/22.
//

import Foundation

/**
 * Provides functionality for using Deezer's search API's
 */
protocol SearchNetworkingProviding: AnyObject {
    typealias ArtistsResult = ((Result<[Artist], Error>) -> Void)

    /**
     * Fetches the search results for the given `artist` name from the Deezer API
     * - parameter artist: The name of the artist to search for
     * - parameter completion: Closure that accepts a Result type where the success case gives an array of `Artist`s
     */
    func fetchArtist(_ artist: String, completion: ArtistsResult?)
}

/// Conforms to `SearchNetworkingProviding` to implement remote networking calls to Deezer's search API
class SearchNetworkingProvider: SearchNetworkingProviding {

    /// The current data task used for searching
    var searchTask: URLSessionDataTask?

    func fetchArtist(_ artist: String, completion: ArtistsResult?) {
        // Cancel any ongoing search tasks before starting a new one
        if let searchTask = searchTask {
            searchTask.cancel()
        }

        guard let url = searchArtistURL(artist: artist) else {
            assertionFailure("Error: Unable to create search URL.")
            return
        }

        let request = loadGETRequest(with: url)

        searchTask = URLSession.shared.dataTask(with: request) { data, result, error in
            if let error = error {
                completion?(.failure(error))
                return
            }

            guard let data = data else {
                completion?(.failure(SearchError.noData))
                return
            }

            if let artistsData = try? JSONDecoder().decode(Artists.self, from: data) {
                DispatchQueue.main.async {
                    completion?(.success(artistsData.artistArray))
                }
            }
        }
        searchTask?.resume()
    }
}

// MARK: - Private
private extension SearchNetworkingProvider {

    enum SearchError: Error {
        case noData
    }

    struct API {
        static let baseURL = "https://api.deezer.com"

        struct Endpoint {
            static let search = "/search"
            static let artist = "/artist"
            static let artistAlbums = "/albums"
            static let albumTracks = "/tracks"
        }
    }

    /// Builds the URL for searching for an Artist
    func searchArtistURL(artist: String) -> URL? {
        guard var searchURLComponents = URLComponents(string: API.baseURL) else {
            assertionFailure("Error: nil searchURLComponents.")
            return nil
        }

        searchURLComponents.path = API.Endpoint.search + API.Endpoint.artist
        searchURLComponents.queryItems = [
            URLQueryItem(name: "q", value: artist)
        ]

        return searchURLComponents.url
    }

    /// Returns a GET URLRequest for the given URL param
    func loadGETRequest(with url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
}
