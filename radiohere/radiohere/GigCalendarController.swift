//
//  MasterViewController.swift
//  radiohere3
//
//  Created by Spencer Ward on 11/07/2014.
//  Copyright (c) 2014 Spencer Ward. All rights reserved.
//

import UIKit

class GigCalendarController: UIViewController, SRWebSocketDelegate, TSQCalendarViewDelegate {
    let SERVER = "ws://radiohere.herokuapp.com/game"
//    let SERVER = "ws://localhost:8025/game"
//    let SERVER = "ws://192.168.1.67:8025/game"
    
    var socket = SRWebSocket()
    var musicScene = MusicScene()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        openWebSocket()
        initCalendar()
        super.viewDidLoad()
    }
    
    func initCalendar() {
        var calendar = TSQCalendarView()
        calendar.firstDate = NSDate()
        calendar.lastDate = NSDate().addMonth(1)
        calendar.selectedDate = nil
        calendar.delegate = self
        self.view = calendar
        
        var modeBar = NSBundle.mainBundle().loadNibNamed("DateMode", owner: self, options: nil)[0] as UIView
        modeBar.frame = CGRectMake(0, 0, 320, 40)
        self.navigationItem.titleView = modeBar
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
        socket.delegate = self
        socket.open()
    }
    
    func webSocketDidOpen(socket: SRWebSocket!) {
        println("Socket Open!")
//        socket.send("51.5262,-0.05938,5.0") // BETHNAL GREEN
        socket.send("51.5403,-0.0884,5.0") // YEATE
//        socket.send("51.5265,-0.0825,2.0") // OLD STREET
//        socket.send("51.484225,-0.022034,20") // LEON
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

