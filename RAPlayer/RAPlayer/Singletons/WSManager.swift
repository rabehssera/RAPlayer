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
    
    func appleMusicTop100(completion:@escaping (Bool, [Track]?, Error?) -> Void) {
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            
            let apiRequest = URLRequest(url: URL(string: "https://itunes.apple.com/\(countryCode)/rss/topsongs/limit=100/json")!)
            
            let dataTask = URLSession.shared.dataTask(with: apiRequest  as URLRequest) { (data, response, error) in
                if (error != nil) {
                    completion(false, nil, error)
                } else {
                    let json = try? JSONSerialization.jsonObject(with: data!, options: [])
                    
                    if let dic = json as? [String : Any] {
                        if let feed = dic["feed"] as? [String: Any] {
                            let songs = feed["entry"] as! [[String: Any]]
                            var tracks = [Track]()
                            var index = 0
                            for song in songs {
                                let track = Track(feed: song)
                                tracks.insert(track, at: index)
                                index = index + 1
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
    }
    
    func search(text: String, completion:@escaping (Bool, [String: Any]?, Error?) -> Void) {
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            let set = CharacterSet.urlQueryAllowed
            let encodedText = text.addingPercentEncoding(withAllowedCharacters: set)
            let urlRequest = "https://itunes.apple.com/search?term=\(encodedText!)&country=\(countryCode)&media=music"
        
            let apiRequest = URLRequest(url: URL(string: urlRequest)!)
            
            let dataTask = URLSession.shared.dataTask(with: apiRequest  as URLRequest) { (data, response, error) in
                if (error != nil) {
                    completion(false, nil, error)
                } else {
                    let json = try? JSONSerialization.jsonObject(with: data!, options: [])
                    
                    var tracks = [Track]()
                    var albums = [Album]()
                    
                    var completeResult: [String: Any] = [:]
                    if let dic = json as? [String : Any] {
                        if let results = dic["results"] as? [[String: Any]] {
                            for result in results {
                                let wrapperType = result["wrapperType"] as! String
                                if wrapperType == "track" {
                                    let track = Track(searchResult: result)
                                    tracks.append(track)
                                } else if wrapperType == "artistFor" {
                                    
                                } else if wrapperType == "collection" {
                                    let album = Album()
                                    albums.append(album)
                                }
                            }
                            completeResult = ["tracks": tracks, "albums": albums]
                            completion(true, completeResult, nil)
                        }
                    }
                }
            }
            
            dataTask.resume()
        }
    }
}
