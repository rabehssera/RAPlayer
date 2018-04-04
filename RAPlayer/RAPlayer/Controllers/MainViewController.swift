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

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(trackDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: Player.sharedInstance.playerItem)
        NotificationCenter.default.addObserver(self, selector: #selector(trackDidStartPlaying), name: Notification.Name(rawValue: "AVPlayerItemDidStartPlaying"), object: nil)
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
    
    @objc func trackDidFinishPlaying(notification: Notification) {
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    
    @objc func trackDidStartPlaying(notification: Notification) {
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }

}
