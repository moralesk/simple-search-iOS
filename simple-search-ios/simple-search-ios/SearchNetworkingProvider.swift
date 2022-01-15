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
protocol SearchNetworkingProviding: NetworkingProviding {
    typealias ArtistsResult = ((Result<[Artist], Error>) -> Void)
    typealias AlbumsResult = ((Result<[Album], Error>) -> Void)

    /**
     * Fetches the search results for the given `artist` name from the Deezer API
     * - parameter artist: The name of the artist to search for
     * - parameter completion: Closure that accepts a Result type where the success case gives an array of `Artist`s
     */
    func fetchArtist(_ artist: String, completion: ArtistsResult?)

    /**
     * Fetches an artist's albums given their `artistID`
     * - parameter artistID: The artist's Deezer ID
     * - parameter completion: Closure that accepts a Result type where the success
     * case gives an array of the artist's `Album`s
     */
    func fetchAlbums(_ artistID: Int, completion: AlbumsResult?)
}

/// Conforms to `SearchNetworkingProviding` to implement remote networking calls to Deezer's search API
class SearchNetworkingProvider: SearchNetworkingProviding, NetworkingProviding {

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
                completion?(.failure(NetworkError.noData))
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

    func fetchAlbums(_ artistID: Int, completion: AlbumsResult?) {
        guard let url = albumsURL(artistID: artistID) else {
            assertionFailure("Error: Unable to create artist albums URL.")
            return
        }

        let request = loadGETRequest(with: url)

        URLSession.shared.dataTask(with: request) { data, result, error in
            if let error = error {
                completion?(.failure(error))
                return
            }

            guard let data = data else {
                completion?(.failure(NetworkError.noData))
                return
            }

            if let albumsData = try? JSONDecoder().decode(Albums.self, from: data) {
                DispatchQueue.main.async {
                    completion?(.success(albumsData.albumsArray))
                }
            }
        }.resume()
    }
}

// MARK: - Private
private extension SearchNetworkingProvider {

    /// Builds the URL for searching for an Artist
    func searchArtistURL(artist: String) -> URL? {
        guard var searchURLComponents = URLComponents(string: DeezerAPI.baseURL) else {
            assertionFailure("Error: nil searchURLComponents.")
            return nil
        }

        searchURLComponents.path = DeezerAPI.Endpoint.search + DeezerAPI.Endpoint.artist
        searchURLComponents.queryItems = [
            URLQueryItem(name: "q", value: artist)
        ]

        return searchURLComponents.url
    }

    /// Builds the URL for retrieving an artist's albums
    func albumsURL(artistID: Int) -> URL? {
        guard var albumsURLComponents = URLComponents(string: DeezerAPI.baseURL) else {
            assertionFailure("Error: nil albumsURLComponents.")
            return nil
        }

        albumsURLComponents.path = DeezerAPI.Endpoint.artist + "/\(artistID)" + DeezerAPI.Endpoint.artistAlbums
        return albumsURLComponents.url
    }
}
