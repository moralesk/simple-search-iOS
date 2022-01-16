//
//  AlbumNetworkingProvider.swift
//  simple-search-ios
//
//  Created by Kelly Morales on 1/15/22.
//

import Foundation

/// Provides functionality for retrieving album details from Deezer's APIs
protocol AlbumNetworkingProviding: AnyObject {
    typealias TracklistResult = ((Result<[Track], Error>) -> Void)

    /**
     * Fetches the tracklist for the given `albumID` from the Deezer API
     * - parameter albumID: The ID of the album we want the tracklist of
     * - parameter completion: Closure that accepts a `Result` type where the success
     * case gives an array of `Track`s in the album
     */
    func fetchAlbumTracklist(albumID: Int, completion: TracklistResult?)
}

/// Conforms to `AlbumNetworkingProviding` to implement remote networking calls to Deezer's album info APIs
class AlbumNetworkingProvider: AlbumNetworkingProviding, NetworkingProviding {

    func fetchAlbumTracklist(albumID: Int, completion: TracklistResult?) {
        guard let url = tracklistURL(albumID: albumID) else {
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

            if let tracklistData = try? JSONDecoder().decode(Tracklist.self, from: data) {
                DispatchQueue.main.async {
                    completion?(.success(tracklistData.tracks))
                }
            }
        }.resume()
    }
}

// MARK: - Private
private extension AlbumNetworkingProvider {

    /// Builds the URL for retrieving an artist's albums
    func tracklistURL(albumID: Int) -> URL? {
        guard var tracklistURLComponents = URLComponents(string: DeezerAPI.baseURL) else {
            assertionFailure("Error: nil albumsURLComponents.")
            return nil
        }

        tracklistURLComponents.path = DeezerAPI.Endpoint.albumDetails + "/\(albumID)" + DeezerAPI.Endpoint.albumTracks
        return tracklistURLComponents.url
    }
}
