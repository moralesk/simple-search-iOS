//
//  ImageNetworkingProvider.swift
//  simple-search-ios
//
//  Created by Kelly Morales on 1/15/22.
//

import UIKit

protocol ImageNetworkingProviding {

    /**
     * Fetches image data given a URL, then converts it to a UIImage
     * - parameter imageURL: URL for an image
     * - parameter completion: Closure that accepts a `Result` type where the success case gives an optional UIImage
     */
    func fetchImage(from imageURL: URL, completion: @escaping (Result<UIImage?, Error>) -> Void)
}

class ImageNetworkingProvider: ImageNetworkingProviding {

    func fetchImage(from imageURL: URL, completion: @escaping (Result<UIImage?, Error>) -> Void) {
        URLSession.shared.dataTask(with: imageURL, completionHandler: { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data,
                  let image = UIImage(data: data) else {
                completion(.failure(NetworkError.noData))
                return
            }

            completion(.success(image))
        }).resume()
    }
}
