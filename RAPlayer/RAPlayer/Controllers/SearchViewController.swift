//
//  SearchViewController.swift
//  RAPlayer
//
//  Created by Raphael Abehssera on 04/04/2018.
//  Copyright © 2018 Raphael Abehssera. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var tracks = [Track]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidChange), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: Player.sharedInstance.playerItem)
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidChange), name: Notification.Name(rawValue: "AVPlayerItemDidStartPlaying"), object: nil)
        
        self.tableView.register(UINib(nibName: "TrackTableViewCell", bundle: nil), forCellReuseIdentifier: "TrackTableViewCell")
        
        searchBar.becomeFirstResponder()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK : UITableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackTableViewCell", for: indexPath) as! TrackTableViewCell
        cell.configure(with: tracks[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchBar.resignFirstResponder()
        Player.sharedInstance.play(track: tracks[indexPath.row], playlist: tracks)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if (Player.sharedInstance.playingTrack != nil) {
            return 50
        } else {
            return CGFloat.leastNormalMagnitude
        }
    }
    
    //MARK : UISearchBar
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        if searchBar.text != nil {
            WSManager.sharedInstance.search(text: searchBar.text!) { (success, result, error) in
                if success {
                    self.tracks = result!["tracks"] as! [Track]
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    //MARK : Notifications
    
    @objc func playerDidChange() {
        self.tableView.reloadData()
    }
    

}
