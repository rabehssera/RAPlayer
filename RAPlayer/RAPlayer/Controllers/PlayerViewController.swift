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
    var context = CIContext(options: nil)
    
    @IBOutlet weak var backgroundPictureView: UIImageView!
    @IBOutlet weak var albumPictureView: UIView!
    @IBOutlet weak var controlsView: UIView!
    @IBOutlet weak var openView: UIView!
    
    
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var artistLbl: UILabel!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    //MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(trackDidStartPlaying), name: Notification.Name(rawValue: "AVPlayerItemDidStartPlaying"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTouchOpenButton(_ sender: Any) {
        if let pulley = self.parent as? PulleyViewController {
            pulley.setDrawerPosition(position: PulleyPosition.open, animated: true)
        }
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
}
