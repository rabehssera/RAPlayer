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
    }
    
}
