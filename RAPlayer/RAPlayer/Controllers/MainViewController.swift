//
//  MainViewController.swift
//  RAPlayer
//
//  Created by Raphael Abehssera on 02/04/2018.
//  Copyright © 2018 Raphael Abehssera. All rights reserved.
//

import UIKit
import Pulley

class MainViewController: PulleyViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(playerDidChange), name: Notification.Name(rawValue: "AVPlayerItemDidStartPlaying"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidStop), name: Notification.Name(rawValue: "AVPlayerItemDidStopPlaying"), object: nil)
        
        self.topInset = 0
        self.drawerCornerRadius = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func playerDidChange(notification: Notification) {
        //Player starting, opening Player View Controller
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    
    @objc func playerDidStop(notification: Notification) {
        //Player is not playing, closing Player View Controller
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        self.setDrawerPosition(position: .collapsed, animated: true)
    }

}
