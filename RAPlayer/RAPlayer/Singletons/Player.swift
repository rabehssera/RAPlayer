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
    static let sharedInstance = Player()
    
    var playerItem: AVPlayerItem? = nil
    var player: AVPlayer? = nil
    var playingTrack: Track? = nil
    var playlist: [Track]? = nil
    var isPlaying = false
    
    func play(track : Track, playlist: [Track]) {
        playerItem = AVPlayerItem(url: URL(string: track.previewURL)!)
        //Subscribing to playerItem notification
        NotificationCenter.default.addObserver(self, selector: #selector(trackDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerItem)
        
        //Stopping player in case already playing
        self.player?.pause()
        self.player = AVPlayer(playerItem: self.playerItem)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            //handle error
            print(error)
        }
        
        //Checking if pausing or playing new track
        
        if (self.playingTrack == track) {
            self.player?.pause()
            self.isPlaying = false
        } else {
            self.player?.pause()
            self.player?.play()
            self.playingTrack = track
            self.isPlaying = true
        }
        
        self.playlist = playlist
        
        //Sending notification that player started
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "AVPlayerItemDidStartPlaying")))
        
    }
    
    func pause() {
        self.isPlaying = false
        self.player?.pause()
    }
    
    func resume() {
        self.isPlaying = true
        self.player?.play()
    }
    
    func playNext() {
        //Checking if next song exists in playlist
        let index = self.playlist?.index(of: self.playingTrack!)
        if let _ = index {
            if (index! + 1) < (self.playlist?.count)! {
                let track = self.playlist![index! + 1]
                self.play(track: track, playlist: playlist!)
            }
        }
    }
    
    func playPrevious() {
        //Checking if song is first (playing same song from start) or going to previous
        let index = self.playlist?.index(of: self.playingTrack!)
        if let _ = index {
            if index! > 0 {
                let track = self.playlist![index! - 1]
                self.play(track: track, playlist: playlist!)
            }
        } else {
            self.play(track: playingTrack!, playlist: playlist!)
        }
    }
    
    @objc func trackDidFinishPlaying(notification: Notification) {
        //Song finished playing and then going next or stopping if last song of playlist
        self.isPlaying = false
        let index = self.playlist?.index(of: self.playingTrack!)
        if let _ = index {
            if (index! + 1) < (self.playlist?.count)! {
                let track = self.playlist![index! + 1]
                self.play(track: track, playlist: playlist!)
            } else {
                self.playingTrack = nil
                self.playlist = nil
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "AVPlayerItemDidStopPlaying")))
            }
        } else {
            self.playingTrack = nil
            self.playlist = nil
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "AVPlayerItemDidStopPlaying")))
        }
    }
    

}
