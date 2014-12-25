//
//  MasterViewController.swift
//  radiohere3
//
//  Created by Spencer Ward on 11/07/2014.
//  Copyright (c) 2014 Spencer Ward. All rights reserved.
//

import UIKit
import CoreLocation


class GigCalendarController: UIViewController, SRWebSocketDelegate, TSQCalendarViewDelegate, CLLocationManagerDelegate {
    let SERVER = "ws://radiohere.herokuapp.com/game"
    
    var location: String?
    var locationName: String?
    var socket: SRWebSocket?
    var musicScene = MusicScene()
    var locationManager = CLLocationManager()
    var locationIndex = 0
    var here: CLLocation!
    var userLocations: [String] = []
    
    //        socket.send("51.5262,-0.05938,5.0") // BETHNAL GREEN
    //socket.send("51.5403,-0.0884,5.0") // YEATE
    //        socket.send("51.5265,-0.0825,2.0") // OLD STREET
    //        socket.send("51.484225,-0.022034,20") // LEON
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var nameTextBox: UITextField!
    @IBOutlet weak var locationLabel: UILabel!
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        here = locations[0] as CLLocation
    }
    
    @IBAction func addLocation(sender: AnyObject) {
        nameTextBox.hidden = false
        addButton.hidden = true
        okButton.hidden = false
        nameTextBox.becomeFirstResponder()
    }
    
    @IBAction func acceptLocation(sender: AnyObject) {
        nameTextBox.hidden = true
        addButton.hidden = false
        okButton.hidden = true
        var locationString = "\(nameTextBox.text):\(here!.coordinate.latitude),\(here!.coordinate.longitude),5"
        userLocations.append(locationString)
        onLocationChange()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        readUserLocations()
        onLocationChange()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        initCalendar()
    }
    
    func readUserLocations() {
        var path = NSBundle.mainBundle().pathForResource("Data", ofType: "plist")
        var props = NSDictionary(contentsOfFile: path!)
        userLocations = props?.valueForKey("Locations") as [String]
    }
    
    func onLocationChange() {
        musicScene = MusicScene()
        updateLocation()
        closeWebSocket()
        openWebSocket()
    }
    
    func updateLocation() {
        var locationDetails = userLocations[locationIndex]
        let split = locationDetails.rangeOfString(":")!.startIndex
        let name: String = locationDetails.substringWithRange(Range<String.Index>(start: locationDetails.startIndex, end: split))
        location = locationDetails.substringWithRange(Range<String.Index>(start: split.successor(), end: locationDetails.endIndex))
        locationName = name
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

        var locationBar = NSBundle.mainBundle().loadNibNamed("LocationView", owner: self, options: nil)[0] as UIView
        showTopBar(locationBar)
        locationLabel.textColor = UIColor.innocence()
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
        
    override func viewDidAppear(animated: Bool) {
//        navigationController?.toolbarHidden = true
    }

    @IBAction func onClickVenue(sender: AnyObject) {
        let secondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("VenuesController") as VenuesController
        secondViewController.musicScene = self.musicScene
    
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    func calendarView(calendarView: TSQCalendarView, shouldSelectDate date: NSDate) -> Bool {
        return musicScene.hasGigOn(date)
    }

    func calendarView(calendarView: TSQCalendarView, didSelectDate date: NSDate) {
        let secondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as DetailViewController
        secondViewController.gigs = self.musicScene.getGigsOn(date)
        secondViewController.showByDate(date.format("EEE dd MMM"))
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }

    func openWebSocket() {
        socket = SRWebSocket(URL: NSURL(string: SERVER))
        socket?.delegate = self
        socket?.open()
    }
    
    func closeWebSocket() {
        if (socket != nil) {
            socket?.close()
        }
    }
    
    func webSocketDidOpen(socket: SRWebSocket!) {
        println("Socket Open!")
        socket.send(location)
        locationLabel.text = locationName
        var timer = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: Selector("updateTable"), userInfo: nil, repeats: true)
    }
    
    func webSocket(webSocket: SRWebSocket!, didReceiveMessage message: AnyObject) {
        objc_sync_enter(self)
        self.musicScene.add(Gig(jsonText: message.description))
        objc_sync_exit(self)
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

