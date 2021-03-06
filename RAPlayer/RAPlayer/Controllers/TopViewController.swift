//
//  TopViewController.swift
//  RAPlayer
//
//  Created by Raphael Abehssera on 03/04/2018.
//  Copyright © 2018 Raphael Abehssera. All rights reserved.
//

import UIKit
import Pulley

class TopViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    var tracks = [Track]()
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Browse"
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidChange), name: Notification.Name(rawValue: "AVPlayerItemDidStopPlaying"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidChange), name: Notification.Name(rawValue: "AVPlayerItemDidStartPlaying"), object: nil)
        
        self.tableView.register(UINib(nibName: "TrackTableViewCell", bundle: nil), forCellReuseIdentifier: "TrackTableViewCell")
        
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITableView
    
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
        Player.sharedInstance.play(track: tracks[indexPath.row], playlist: tracks)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if (Player.sharedInstance.playingTrack != nil) {
            return Constants.collapsedPlayerHeight
        } else {
            return CGFloat.leastNormalMagnitude
        }
    }
    
    //MARK: UISearchBar Delegate
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController")
        self.navigationController?.pushViewController(vc!, animated: false)
        self.searchBar.resignFirstResponder()
    }
    
    //Refresh control
    
    @IBAction func didTouchRefreshButton(_ sender: Any) {
        loadData()
    }
    
    func loadData() {
        // Fetching Top 100
        WSManager.sharedInstance.appleMusicTop100 { (success, tracks, error) in
            if success {
                self.tracks = tracks!
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                let alert = UIAlertController(title: "Error", message: (error != nil ? error?.localizedDescription : "An error occured"), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    
                }))
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    //MARK: Notifications
    @objc func playerDidChange() {
        self.tableView.reloadData()
    }
    
}
