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
    var audioPlayer = AVPlayer()
    var playinggig : Gig?
    var trackIndex = 0
    var timer : NSTimer = NSTimer()
    
    @IBOutlet var myPlayer: UIView
    @IBOutlet var songTitle: UILabel
    @IBOutlet var nextTrack: UIButton
    
    var gigs: NSMutableArray = NSMutableArray() {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    @IBAction func touchNext(sender: AnyObject) {
        trackIndex++
        if (playinggig?.tracks().count <= trackIndex) {
            trackIndex = 0
        }
        playTrack()
    }
    
    
    func configureView() {
        self.navigationItem.title = gigs.count > 0 ? (gigs[0] as Gig).date() : ""
    }

    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath
        indexPath: NSIndexPath!) {
        trackIndex = 0
        playinggig = gigs[indexPath.row] as Gig
        playTrack()
    }
    
    func playTrack() {
        audioPlayer = AVPlayer(URL: playinggig!.tracks()[trackIndex].streamUrl())
        audioPlayer.play()
        songTitle.text = playinggig!.tracks()[trackIndex].name()
        nextTrack.hidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        println("CREATING DETAIL VIEW \(self)")
        timer = NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
        
        var myPlayer = NSBundle.mainBundle().loadNibNamed("PlayerView", owner: self, options: nil)[0] as UIView
        var myItems = NSMutableArray()
        myPlayer.frame = CGRectMake(0, 0, 320, 40)
        var item = UIBarButtonItem(customView: myPlayer)
        myItems.addObject(item)
        
        toolbarItems = myItems
    }
    
    func update() {
        let selected = self.tableView.indexPathForSelectedRow()
        self.tableView.reloadData()
        self.tableView.selectRowAtIndexPath(selected, animated: false, scrollPosition: UITableViewScrollPosition.None)
    }
    
    override func viewDidDisappear(animated: Bool) {
        println("KILLING DETAIL VIEW \(self)")
        audioPlayer.pause()
        gigs = NSMutableArray()
        timer.invalidate()
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
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyCell")
        let gig = gigs[indexPath.row] as Gig
        cell.textLabel.text = gig.artist()
        cell.detailTextLabel.text = "\(gig.venue()) (\(gig.distance())km)"
        return cell
    }
}

