//
//  PlayerViewController.swift
//  RAPlayer
//
//  Created by Raphael Abehssera on 03/04/2018.
//  Copyright © 2018 Raphael Abehssera. All rights reserved.
//

import UIKit
import Pulley

class PlayerViewController: UIViewController, PulleyDrawerViewControllerDelegate {
    @IBOutlet weak var albumPictureView: UIView!
    @IBOutlet weak var controlsView: UIView!
    
    
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var artistLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(trackDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: Player.sharedInstance.playerItem)
        NotificationCenter.default.addObserver(self, selector: #selector(trackDidStartPlaying), name: Notification.Name(rawValue: "AVPlayerItemDidStartPlaying"), object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func collapsedDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        if (Player.sharedInstance.playingTrack != nil) {
            return 50
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

    @objc func trackDidFinishPlaying(notification: Notification) {
        
    }
    
    @objc func trackDidStartPlaying(notification: Notification) {
        let track = Player.sharedInstance.playingTrack
        
        picture.sd_setImage(with: URL(string: (track?.picture)!), completed: nil)
        titleLbl.text = track?.title
        artistLbl.text = track?.artist
    }
    
    func drawerPositionDidChange(drawer: PulleyViewController, bottomSafeArea: CGFloat) {
        if (drawer.drawerPosition == .collapsed) {
            albumPictureView.isHidden = true
            controlsView.isHidden = true
        } else {
            albumPictureView.isHidden = false
            controlsView.isHidden = false
        }
    }
}
