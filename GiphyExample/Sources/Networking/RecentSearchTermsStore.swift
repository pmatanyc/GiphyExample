//
//  RecentSearchTermsStore.swift
//  GiphyExample
//
//  Created by Paola Mata on 9/9/18.
//  Copyright © 2018 Paola Mata. All rights reserved.
//

import Foundation

class RecentSearchTermsStore {
    static let shared = RecentSearchTermsStore()
    private let queue = DispatchQueue(label: "com.giphyexample.recent-search-terms")

    private let fileManager = FileManager.default
    
    var fileURL: URL {
        let fileURL = self.fileManager.urls(for: .libraryDirectory, in: .userDomainMask)[0]
        return fileURL.appendingPathComponent("RecentSearchTerms.plist")
    }
    
    func saveSearchTerm(_ term: String) {
        queue.async {
            var searchTerms = [term]
            do {
                let data = try Data(contentsOf: self.fileURL)
                let decoder = PropertyListDecoder()
                let terms = try decoder.decode([String].self, from: data)
                searchTerms.append(contentsOf: terms)
            } catch let error {
                NSLog(error.localizedDescription)
            }
            
            do {
                let encoder = PropertyListEncoder()
                let encodedData = try encoder.encode(searchTerms)
                try encodedData.write(to: self.fileURL)
            } catch let error {
                NSLog(error.localizedDescription)
            }
        }
    }
    
    func getSearchTerms(completion: @escaping ([String]) -> ()) {
        queue.async {
            var searchTerms: [String] = ["trending"]
            do {
                let data = try Data(contentsOf: self.fileURL)
                let decoder = PropertyListDecoder()
                let terms = try decoder.decode([String].self, from: data)
                searchTerms.append(contentsOf: terms)
            } catch let error {
                NSLog(error.localizedDescription)
            }
            
            DispatchQueue.main.async {
                completion(searchTerms)
            }
        }
    }
}
