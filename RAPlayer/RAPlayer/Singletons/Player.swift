//
//  Player.swift
//  RAPlayer
//
//  Created by Raphael Abehssera on 03/04/2018.
//  Copyright © 2018 Raphael Abehssera. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import AudioToolbox

class Player {
    static let sharedInstance = WSManager()
    
    var playerItem: AVPlayerItem? = nil
    var player: AVPlayer? = nil
    var playingTrack: Track? = nil
    var playlist: [Track]? = nil
    
    func play(track : Track, playlist: [Track]) {
        playerItem = AVPlayerItem(url: URL(string: track.previewURL)!)
        NotificationCenter.default.addObserver(self, selector: #selector(trackDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerItem)
        self.player?.pause()
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            //handle error
            print(error)
        }
        
        self.player = AVPlayer(playerItem: self.playerItem)
        
        if (self.playingTrack == track) {
            self.player?.pause()
        } else {
            self.player?.pause()
            self.player?.play()
            self.playingTrack = track
        }
        
        self.playlist = playlist
        
    }
    
    @objc func trackDidFinishPlaying(notification: Notification) {
        let index = self.playlist?.index(of: self.playingTrack!)
        if let _ = index {
            let track = self.playlist![index! + 1]
            self.play(track: track, playlist: playlist!)
        }
    }
    

}