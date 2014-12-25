//
//  MasterViewController.swift
//  radiohere3
//
//  Created by Spencer Ward on 11/07/2014.
//  Copyright (c) 2014 Spencer Ward. All rights reserved.
//

import UIKit
import CoreLocation


class GigCalendarController: UIViewController, TSQCalendarViewDelegate {
    var locationController = LocationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCalendar()
        locationController.viewDidLoad()
        var timer = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: Selector("updateTable"), userInfo: nil, repeats: true)
    }
    
    
    func initCalendar() {
        var calendar = TSQCalendarView()
        calendar.firstDate = NSDate()
        calendar.lastDate = NSDate().addMonth(1)
        calendar.selectedDate = nil
        calendar.delegate = self
        calendar.backgroundColor = UIColor.bond()
        calendar.tintColor = UIColor.bond()
        self.view = calendar
        
        var modeBar = NSBundle.mainBundle().loadNibNamed("DateMode", owner: self, options: nil)[0] as UIView
        showBottomBar(modeBar)

        var locationBar = NSBundle.mainBundle().loadNibNamed("LocationView", owner: locationController, options: nil)[0] as UIView
        showTopBar(locationBar)
    }
    
    func showTopBar(view: UIView) {
        view.frame = CGRectMake(0, 0, 380, 40)
        self.navigationItem.titleView = view
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.innocence()]
        self.navigationController?.navigationBar.barTintColor = UIColor.pachyderm()
        self.navigationController?.navigationBar.tintColor = UIColor.innocence()
    }
    
    func showBottomBar(view: UIView) {
        self.navigationController?.toolbar.barStyle = UIBarStyle.BlackTranslucent
        self.navigationController?.toolbar.barTintColor = UIColor.pachyderm()
        navigationController?.toolbarHidden = false
        var myItems = NSMutableArray()
        view.frame = CGRectMake(0, 0, 320, 40)
        var item = UIBarButtonItem(customView: view)
        myItems.addObject(item)
        toolbarItems = myItems
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
        
    @IBAction func onClickVenue(sender: AnyObject) {
        let secondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("VenuesController") as VenuesController
        secondViewController.musicScene = locationController.musicScene
    
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    func calendarView(calendarView: TSQCalendarView, shouldSelectDate date: NSDate) -> Bool {
        return locationController.getMusicScene().hasGigOn(date)
    }

    func calendarView(calendarView: TSQCalendarView, didSelectDate date: NSDate) {
        let secondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as DetailViewController
        secondViewController.gigs = locationController.getMusicScene().getGigsOn(date)
        secondViewController.showByDate(date.format("EEE dd MMM"))
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }

    func updateTable() {
        (self.view as TSQCalendarView).tableView.reloadData()
    }
    
    func webSocket(webSocket: SRWebSocket!, didFailWithError error: NSError) {
        println("Error: \(error.description)")
    }
    
    func webSocket(webSocket: SRWebSocket!, didCloseWithCode code: NSInteger, reason: NSString) {
        println("Close")
    }
}

