//
//  DetailViewController.swift
//  radiohere3
//
//  Created by Spencer Ward on 11/07/2014.
//  Copyright (c) 2014 Spencer Ward. All rights reserved.
//

import UIKit
import AVFoundation

class DetailViewController: UITableViewController {
    var helper: ControllerHelper?
    var audioPlayer = AVPlayer()
    var selected : Gig?
    var trackIndex = 0
    var timer : NSTimer = NSTimer()
    var byVenue : Bool = false
    var playerShown = false
    
    @IBOutlet var myPlayer: UIView?
    @IBOutlet var songTitle: UILabel?
    @IBOutlet var nextTrack: UIButton?
    @IBOutlet var tickets: UIButton?
    
    var gigs: [Gig] = []
    
    @IBAction func touchTickets(sender: AnyObject) {
        let secondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SongkickViewController") as! SongkickViewController
        secondViewController.url = selected?.songkickUrl()
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }

    @IBAction func touchNext(sender: AnyObject) {
        trackIndex++
        if (selected?.tracks().count <= trackIndex) {
            trackIndex = 0
        }
        playTrack()
    }
    
    func showByVenue(venue: String) {
        self.navigationItem.title = venue
        byVenue = true
    }
    
    func showByDate(date: String) {
        self.navigationItem.title = date
        byVenue = false
    }

    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath
        indexPath: NSIndexPath!) {
        trackIndex = 0
        selected = gigs[indexPath.row] as Gig

        if (!playerShown) {
            helper?.showBottomBar("PlayerView", owner: self)
            playerShown = true
        }
        playTrack()
    }
    
    func playTrack() {
        var url = selected!.tracks()[trackIndex].streamUrl()
        audioPlayer = AVPlayer(URL: url)
        audioPlayer.play()
        songTitle?.text = selected!.tracks()[trackIndex].name() as String
        songTitle?.textColor = UIColor.innocence()
        nextTrack?.hidden = false
        tickets?.hidden = false
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func viewDidAppear(animated: Bool) {
        navigationController?.toolbarHidden = true
        playerShown = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        helper = ControllerHelper(controller: self)

        timer = NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
        
        self.view.backgroundColor = UIColor.bond()
    }
    
    func update() {
        let selected = self.tableView.indexPathForSelectedRow
        self.tableView.reloadData()
        self.tableView.selectRowAtIndexPath(selected, animated: false, scrollPosition: UITableViewScrollPosition.None)
    }
    
    override func viewDidDisappear(animated: Bool) {
        print("KILLING DETAIL VIEW \(self)")
        audioPlayer.pause()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gigs.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyCell")
        let gig = gigs[indexPath.row] as Gig
        cell.textLabel?.text = gig.artist()
        cell.textLabel?.textColor = UIColor.pachyderm()
        cell.detailTextLabel?.textColor = UIColor.pachyderm(0.8)
        cell.backgroundColor = UIColor.bond()
        if byVenue {
            cell.detailTextLabel?.text = "\(gig.date())"
        } else {
            cell.detailTextLabel?.text = "\(gig.venue()) (\(gig.distance())km)"
        }
        
        return cell
    }
}

