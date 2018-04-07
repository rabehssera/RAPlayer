//
//  WSManager.swift
//  qontoTest
//
//  Created by Raphael Abehssera on 03/04/2018.
//  Copyright © 2018 Raphael Abehssera. All rights reserved.
//

import UIKit

class WSManager {
    static let sharedInstance = WSManager()
    fileprivate let countryCode: String = (Locale.current as NSLocale).object(forKey: .countryCode) as! String
    
    func appleMusicTop100(completion:@escaping (Bool, [Track]?, Error?) -> Void) {
        //Fetching from RSS Feed
        
        let apiRequest = URLRequest(url: URL(string: "https://itunes.apple.com/\(countryCode)/rss/topsongs/limit=100/json")!)
        
        let dataTask = URLSession.shared.dataTask(with: apiRequest  as URLRequest) { (data, response, error) in
            if (error != nil) {
                completion(false, nil, error)
            } else {
                //Checking format
                let json = try? JSONSerialization.jsonObject(with: data!, options: [])
                
                if let dic = json as? [String : Any] {
                    if let feed = dic["feed"] as? [String: Any] {
                        let songs = feed["entry"] as! [[String: Any]]
                        var tracks = [Track]()
                        for song in songs {
                            let track = Track(feed: song)
                            tracks.append(track)
                        }
                        completion (true,tracks, nil)
                    } else {
                        completion(false, nil, nil)
                    }
                }
            }
        }
        
        dataTask.resume()
    }
    
    func search(text: String, completion:@escaping (Bool, [Track]?, Error?) -> Void) {
        //Creating search adequate for URL
        let set = CharacterSet.urlQueryAllowed
        let encodedText = text.addingPercentEncoding(withAllowedCharacters: set)
        //Fetching from Search API
        let urlRequest = "https://itunes.apple.com/search?term=\(encodedText!)&country=\(countryCode)&media=music&limit=200"
        
        let apiRequest = URLRequest(url: URL(string: urlRequest)!)
        
        let dataTask = URLSession.shared.dataTask(with: apiRequest  as URLRequest) { (data, response, error) in
            if (error != nil) {
                completion(false, nil, error)
            } else {
                //Checking format
                let json = try? JSONSerialization.jsonObject(with: data!, options: [])
                var tracks = [Track]()
                if let dic = json as? [String : Any] {
                    if let results = dic["results"] as? [[String: Any]] {
                        for result in results {
                            let wrapperType = result["wrapperType"] as! String
                            if wrapperType == "track" {
                                let track = Track(searchResult: result)
                                tracks.append(track)
                            }
                        }
                        completion(true, tracks, nil)
                    } else {
                        completion (false, nil, nil)
                    }
                } else {
                    completion (false, nil, nil)
                }
            }
        }
        
        dataTask.resume()
    }
}

