//
//  Track.swift
//  RAPlayer
//
//  Created by Raphael Abehssera on 03/04/2018.
//  Copyright © 2018 Raphael Abehssera. All rights reserved.
//

import UIKit

class Track: NSObject {
    
    var album: Album = Album()
    var artist = ""
    var title = ""
    var picture = ""
    var previewURL = ""
    
    init(feed: [String: Any]) {
        super.init()
        
        if let title = feed["title"] as? [String: Any] {
            self.title = title["label"] as! String
        }
        
        if let artist = feed["im:artist"] as? [String: Any] {
            self.artist = artist["label"] as! String
        }
        
        if let pictures = feed["im:image"] as? [Any] {
            if let picture = pictures.last as? [String: Any] {
                self.picture = picture["label"] as! String
            }
        }
        
        
        if let links = feed["link"] as? [Any] {
            if let link = links.last as? [String: Any] {
                if let attributes = link["attributes"] as? [String: Any] {
                    self.previewURL = attributes["href"] as! String
                }
            }
        }
    }

}
