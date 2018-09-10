//
//  APIClient.swift
//  GiphyExample
//
//  Created by Paola Mata on 9/8/18.
//  Copyright © 2018 Paola Mata. All rights reserved.
//

import Foundation

typealias GiphyCompletion = ([Gif]) -> Void

class GiphyAPIClient {
    static let shared = GiphyAPIClient()
    let baseURLString = "https://api.giphy.com/v1/gifs/"
    
    func searchGif(for searchTerm: String, completion: @escaping GiphyCompletion) {
        if
            let urlSafeSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed),
            let baseURL = URL(string: baseURLString),
            let url = URL(string: "search?q=\(urlSafeSearchTerm)", relativeTo: baseURL)
        {
            fetchGifs(with: url, completion: completion)
        }
    }
    
    func fetchGifs(with url: URL, completion: @escaping GiphyCompletion) {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return }
        
        urlComponents.queryItems?.append(URLQueryItem(name: "api_key", value: "IPG1qAWWNgCxAasiwFU0u2SjT2uIMaXV"))
        
        if let apiURL = urlComponents.url {
            let request = URLRequest(url: apiURL)
            let session = URLSession.shared
            var gifs: [Gif] = []
            
            let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
                if let error = error {
                    DispatchQueue.main.async {
                        NSLog(error.localizedDescription)
                    }
                } else if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                        gifs = GifParser.parseGifs(for: json)
                    } catch let error {
                        DispatchQueue.main.async {
                            NSLog(error.localizedDescription)
                        }
                        return
                    }
                }
                DispatchQueue.main.async {
                    completion(gifs)
                }
            })
            task.resume()
        }
    }
}

