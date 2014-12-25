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
    
    @IBAction func onClickVenue(sender: AnyObject) {
        let gigListController = self.storyboard?.instantiateViewControllerWithIdentifier("VenuesController") as VenuesController
        gigListController.setRelatedLocationController(locationController)
        self.navigationController?.pushViewController(gigListController, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        navigationController?.toolbarHidden = false
    }

    func setRelatedLocationController(locationController: LocationController) {
        self.locationController.setRelated(locationController)
    }
    
    func calendarView(calendarView: TSQCalendarView, shouldSelectDate date: NSDate) -> Bool {
        return locationController.getMusicScene().hasGigOn(date)
    }

    func calendarView(calendarView: TSQCalendarView, didSelectDate date: NSDate) {
        let gigListController = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as DetailViewController
        gigListController.gigs = locationController.getMusicScene().getGigsOn(date)
        gigListController.showByDate(date.format("EEE dd MMM"))
        self.navigationController?.pushViewController(gigListController, animated: true)
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

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
        helper?.showBottomBar("DateMode", owner: self)
    }
    
    func initLocationBar() {
        helper?.showTopBar("LocationView", owner: locationController)
    }
}

