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
    var helper: ControllerHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        helper = ControllerHelper(controller: self)
        initCalendar()
        initModeBar()
        initLocationBar()
        locationController.viewDidLoad()
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
        NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: Selector("updateCalendar"), userInfo: nil, repeats: true)
    }

    func updateCalendar() {
        (self.view as TSQCalendarView).tableView.reloadData()
    }
    
    func initModeBar() {
        var modeBar = NSBundle.mainBundle().loadNibNamed("DateMode", owner: self, options: nil)[0] as UIView
        helper?.showBottomBar(modeBar)
    }
    
    func initLocationBar() {
        var locationBar = NSBundle.mainBundle().loadNibNamed("LocationView", owner: locationController, options: nil)[0] as UIView
        helper?.showTopBar(locationBar)
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

}

