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
    var locationController = LocationController()
    var helper: ControllerHelper?
    
    @IBAction func onClickDates(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
        (self.navigationController?.topViewController as GigCalendarController).setRelatedLocationController(locationController)
    }
    
    func setRelatedLocationController(locationController: LocationController) {
        self.locationController.setRelated(locationController)
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func viewDidAppear(animated: Bool) {
        navigationController?.toolbarHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        helper = ControllerHelper(controller: self)
        initTable()
        initModeBar()
        initLocationBar()
    }
    
    func initTable() {
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateTable"), userInfo: nil, repeats: true)
    }
    
    func updateTable() {
        let selected = self.tableView.indexPathForSelectedRow()
        self.tableView.reloadData()
    }
    
    func initModeBar() {
        helper?.showBottomBar("VenueMode", owner: self)
        self.navigationItem.hidesBackButton = true
    }
    
    func initLocationBar() {
        helper?.showTopBar("LocationView", owner: locationController)
        locationController.updateLabel()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationController.getMusicScene().getVenues().count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "MyCell")
        let venue = locationController.getMusicScene().getVenues()[indexPath.row] as Venue
        cell.textLabel?.text = "\(venue.name) (\(venue.distance)km)"
        cell.textLabel?.textColor = UIColor.pachyderm()
        cell.backgroundColor = UIColor.bond()
        return cell
    }

    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        var cell = tableView.cellForRowAtIndexPath(indexPath)!
        var venue = cell.textLabel?.text?.componentsSeparatedByString(" (")[0]
        let gigListController = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as DetailViewController
        gigListController.gigs = locationController.getMusicScene().getGigsAt(venue!)
        gigListController.showByVenue(venue!)
        self.navigationController?.pushViewController(gigListController, animated: true)
    }
}

