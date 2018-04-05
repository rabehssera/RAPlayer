//
//  PlayerViewController.swift
//  RAPlayer
//
//  Created by Raphael Abehssera on 03/04/2018.
//  Copyright © 2018 Raphael Abehssera. All rights reserved.
//

import UIKit
import Pulley
import AVKit
import AVFoundation
import AudioToolbox
import MarqueeLabel

class PlayerViewController: UIViewController, PulleyDrawerViewControllerDelegate {
    var context = CIContext(options: nil)
    
    @IBOutlet weak var backgroundPictureView: UIImageView!
    @IBOutlet weak var albumPictureView: UIView!
    @IBOutlet weak var controlsView: UIView!
    @IBOutlet weak var openView: UIView!
    
    
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var titleLbl: MarqueeLabel!
    @IBOutlet weak var artistLbl: MarqueeLabel!
    
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var totalTimeLbl: UILabel!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    var playbackTimeObserver: Any?
    
    //MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(trackDidStartPlaying), name: Notification.Name(rawValue: "AVPlayerItemDidStartPlaying"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(trackDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: Player.sharedInstance.playerItem)
        
        titleLbl.type = .leftRight
        artistLbl.type = .leftRight
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @IBAction func didTouchOpenButton(_ sender: Any) {
        if let pulley = self.parent as? PulleyViewController {
            pulley.setDrawerPosition(position: PulleyPosition.open, animated: true)
        }
    }
    
    @IBAction func didTouchPreviousButton(_ sender: Any) {
        Player.sharedInstance.playPrevious()
    }
    
    @IBAction func didTouchNextButton(_ sender: Any) {
        Player.sharedInstance.playNext()
    }
    
    @IBAction func didTouchPlayPauseButton(_ sender: Any) {
        
    }
    
    
    
    // MARK: Pulley Delegate
    
    func collapsedDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        if (Player.sharedInstance.playingTrack != nil) {
            return 75
        } else {
            return 0
        }
    }
    
    func partialRevealDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return self.view.frame.size.height
    }
    
    func supportedDrawerPositions() -> [PulleyPosition] {
        return [PulleyPosition.collapsed, PulleyPosition.open]
    }
    
    func drawerPositionDidChange(drawer: PulleyViewController, bottomSafeArea: CGFloat) {
        if (drawer.drawerPosition == .collapsed) {
            albumPictureView.isHidden = true
            controlsView.isHidden = true
            openView.isHidden = false
        } else {
            albumPictureView.isHidden = false
            controlsView.isHidden = false
            openView.isHidden = true
        }
    }
    
    //MARK: Notification
    
    @objc func trackDidStartPlaying(notification: Notification) {
        let track = Player.sharedInstance.playingTrack
        
        backgroundPictureView.sd_setImage(with: URL(string: (track?.picture)!)) { (image, error, cacheType, url) in
            self.blurEffect()
        }
        
        picture.sd_setImage(with: URL(string: (track?.picture)!), completed: nil)
        titleLbl.text = track?.title
        artistLbl.text = track?.artist
        
        let interval = CMTimeMake(1, Int32(NSEC_PER_SEC))
        playbackTimeObserver = Player.sharedInstance.player?.addPeriodicTimeObserver(forInterval: interval, queue: nil, using: { (time) in
            
            let duration = CMTimeGetSeconds((Player.sharedInstance.playerItem?.duration)!)
            self.progressView.progress = Float(CMTimeGetSeconds(time)/duration)
            
            if !(duration.isNaN) {
                var (_, m, s) = self.secondsToHoursMinutesSeconds(seconds: Int(duration))
                self.totalTimeLbl.text = "\(String(format: "%02d", m)):\(String(format: "%02d", s))"
                
                (_, m, s) = self.secondsToHoursMinutesSeconds (seconds: Int(CMTimeGetSeconds(time)))
                self.durationLbl.text = "\(String(format: "%02d", m)):\(String(format: "%02d", s))"
            }
            
        })
    }
    
    @objc func trackDidFinishPlaying(notification: Notification) {
        if let _ = self.playbackTimeObserver {
            Player.sharedInstance.player?.removeTimeObserver(self.playbackTimeObserver!)
        }
    }
    
    // MARK: Utils
    
    func blurEffect() {
        let currentFilter = CIFilter(name: "CIGaussianBlur")
        let beginImage = CIImage(image: backgroundPictureView.image!)
        currentFilter!.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter!.setValue(10, forKey: kCIInputRadiusKey)
        
        let cropFilter = CIFilter(name: "CICrop")
        cropFilter!.setValue(currentFilter!.outputImage, forKey: kCIInputImageKey)
        cropFilter!.setValue(CIVector(cgRect: beginImage!.extent), forKey: "inputRectangle")
        
        let output = cropFilter!.outputImage
        let cgimg = context.createCGImage(output!, from: output!.extent)
        let processedImage = UIImage(cgImage: cgimg!)
        backgroundPictureView.image = processedImage
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}
