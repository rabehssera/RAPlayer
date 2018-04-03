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
    
    init(dict: [String: Any]) {
        super.init()
        
        if let title = dict["title"] as? [String: Any] {
            self.title = title["label"] as! String
        }
        
        if let artist = dict["im:artist"] as? [String: Any] {
            self.artist = artist["label"] as! String
        }
        
        if let pictures = dict["im:image"] as? [Any] {
            if let picture = pictures.last as? [String: Any] {
                self.picture = picture["label"] as! String
            }
        }
    }

}
