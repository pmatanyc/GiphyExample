//
//  GifParser.swift
//  GiphyExample
//
//  Created by Paola Mata on 9/8/18.
//  Copyright © 2018 Paola Mata. All rights reserved.
//

import Foundation

class GifParser {
    class func parseGifs(for json: Any) -> [Gif] {
        if
            let dictionary = json as? [String : Any],
            let gifDicts = dictionary["data"] as? [Any]
        {
            var gifs = [Gif]()
            
            for gifDict in gifDicts {
                if
                    let gifDict = gifDict as? [String : Any],
                    let title = gifDict["title"] as? String,
                    let images = gifDict["images"] as? [String : Any],
                    let image = images["fixed_width"] as? [String : Any],
                    let urlString = image["url"] as? String,
                    let url = URL(string: urlString)
                {
                    let gif = Gif(url: url, title: title)
                    gifs.append(gif)
                }
            }
            return gifs
        }
        return []
    }
}
