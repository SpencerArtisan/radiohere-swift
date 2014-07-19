//
//  MasterViewController.swift
//  radiohere3
//
//  Created by Spencer Ward on 11/07/2014.
//  Copyright (c) 2014 Spencer Ward. All rights reserved.
//

import UIKit


class MasterViewController: UITableViewController, SRWebSocketDelegate {

    var objects = NSMutableArray()


    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        openWebSocket()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // #pragma mark - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            let indexPath = self.tableView.indexPathForSelectedRow()
            let object = objects[indexPath.row] as NSDate
            (segue.destinationViewController as DetailViewController).detailItem = object
        }
    }

    // #pragma mark - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        let object = objects[indexPath.row] as NSDate
        cell.textLabel.text = object.description
        return cell
    }
    
    func openWebSocket() {
        socket = SRWebSocket(URL: NSURL.URLWithString(SERVER))
        socket.delegate = self
        socket.open()
    }
    
    func webSocketDidOpen(webSocket: SRWebSocket!) {
        println("Socket Open!")
    }
    
    func webSocket(webSocket: SRWebSocket!, didReceiveMessage message: AnyObject) {
        objc_sync_enter(self)
        println("Received message from server: \(message)")
        
        var artist = Artist(jsonText: message.description)
        var artists : Array<Artist>
        if tableData[artist.date()] {
            artists = tableData[artist.date()]!
            artists.append(artist)
            tableData[artist.date()] = artists
            println("Date \(artist.date()) now has \(artists.count) items")
        } else {
            artists = Array<Artist>()
            artists.append(artist)
            tableData[artist.date()] = artists
        }
        
        artistsTableView.reloadData()
        objc_sync_exit(self)
    }
    
    func webSocket(webSocket: SRWebSocket!, didFailWithError error: NSError) {
        println("Error: \(error.description)")
    }
    
    func webSocket(webSocket: SRWebSocket!, didCloseWithCode code: NSInteger, reason: NSString) {
        println("Close")
    }
}

