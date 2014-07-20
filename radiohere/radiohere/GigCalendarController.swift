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
    
    var socket = SRWebSocket()
    var tableData = Dictionary<NSDate, NSMutableArray>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        navigationItem.title = "Radiohere"
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
    }
    
    func calendarView(calendarView: TSQCalendarView, shouldSelectDate date: NSDate) -> Bool {
        return tableData[date] != nil
    }

    func calendarView(calendarView: TSQCalendarView, didSelectDate date: NSDate) {
        println(date)
        let gigs = tableData[date]
        let secondViewController = self.storyboard.instantiateViewControllerWithIdentifier("DetailViewController") as DetailViewController
        secondViewController.gigs = gigs!
        self.navigationController.pushViewController(secondViewController, animated: true)
        
    }

    func openWebSocket() {
        socket = SRWebSocket(URL: NSURL.URLWithString(SERVER))
        socket.delegate = self
        socket.open()
    }
    
    func webSocketDidOpen(socket: SRWebSocket!) {
        println("Socket Open!")
//        socket.send("51.5403,-0.0884,5.0") // YEATE
//        socket.send("51.5265,-0.0825,2.0") // OLD
        socket.send("51.484225,-0.022034,20") // LEON
        var timer = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: Selector("updateTable"), userInfo: nil, repeats: true)
    }
    
    func webSocket(webSocket: SRWebSocket!, didReceiveMessage message: AnyObject) {
        objc_sync_enter(self)
        
        var gig = Gig(jsonText: message.description)
        println("Received gig from server: \(gig)")
        
        if gig.hasTrack() {
            var gigs : NSMutableArray
            if tableData[gig.nsDate()] {
                gigs = tableData[gig.nsDate()]!
                gigs.addObject(gig)
                tableData[gig.nsDate()] = gigs
            } else {
                gigs = NSMutableArray()
                gigs.addObject(gig)
                tableData[gig.nsDate()] = gigs
            }
        } else {
            println("IGNORING TRACKLESS gig \(gig)")
        }
        
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

