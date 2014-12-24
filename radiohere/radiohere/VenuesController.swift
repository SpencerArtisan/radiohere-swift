//
//  VenuesController.swift
//  radiohere3
//
//  Created by Spencer Ward on 21/12/2014.
//  Copyright (c) 2014 Spencer Ward. All rights reserved.
//

import UIKit
import AVFoundation

class VenuesController: UITableViewController {
    var timer : NSTimer = NSTimer()
    
    var musicScene: MusicScene = MusicScene()
    
    @IBAction func onClickDates(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func viewDidAppear(animated: Bool) {
//        navigationController?.toolbarHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        timer = NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
    
        var modeBar = NSBundle.mainBundle().loadNibNamed("VenueMode", owner: self, options: nil)[0] as UIView
        showBottomBar(modeBar)
        self.navigationItem.hidesBackButton = true
    }
    
    func showBottomBar(view: UIView) {
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.innocence()]
        self.navigationController?.toolbar.barStyle = UIBarStyle.BlackTranslucent
        self.navigationController?.toolbar.barTintColor = UIColor.pachyderm()
        self.navigationController?.navigationBar.tintColor = UIColor.innocence()
        navigationController?.toolbarHidden = false
        var myItems = NSMutableArray()
        view.frame = CGRectMake(0, 0, 320, 40)
        var item = UIBarButtonItem(customView: view)
        myItems.addObject(item)
        toolbarItems = myItems
    }
    
    func update() {
        let selected = self.tableView.indexPathForSelectedRow()
        self.tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.musicScene.getVenues().count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "MyCell")
        let venue = self.musicScene.getVenues()[indexPath.row] as Venue
        cell.textLabel?.text = "\(venue.name) (\(venue.distance)km)"
        cell.textLabel?.textColor = UIColor.pachyderm()
        cell.backgroundColor = UIColor.bond()
        return cell
    }

    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        var cell = tableView.cellForRowAtIndexPath(indexPath)!
        var venue = cell.textLabel?.text?.componentsSeparatedByString(" (")[0]
        let secondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as DetailViewController
        secondViewController.gigs = self.musicScene.getGigsAt(venue!)
        secondViewController.showByVenue(venue!)
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
}

