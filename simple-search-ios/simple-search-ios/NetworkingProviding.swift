//
//  NetworkingProviding.swift
//  simple-search-ios
//
//  Created by Kelly Morales on 1/15/22.
//

import Foundation

/// General functionality for NetworkingProviders
protocol NetworkingProviding: AnyObject {

    /// Returns a GET URLRequest for the given URL
    func loadGETRequest(with url: URL) -> URLRequest
}

extension NetworkingProviding {

    // Default implementation for NetworkingProviders
    func loadGETRequest(with url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
}

/// General errors that can occur while making an API call in the app
enum NetworkError: Error {
    case noData
}
