//
//  LocationController.swift
//  radiohere
//
//  Created by Spencer Ward on 25/12/2014.
//  Copyright (c) 2014 Spencer Ward. All rights reserved.
//

import Foundation
import CoreLocation

class LocationController: UIViewController, SRWebSocketDelegate, CLLocationManagerDelegate {
    let SERVER = "ws://radiohere.herokuapp.com/game"    
    
    var socket: SRWebSocket?

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var nameTextBox: UITextField!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!

    var location: String?
    var locationName: String?
    var props: NSDictionary?
    var userLocations: [String] = []
    var locationIndex = 0
    var locationManager = CLLocationManager()
    var here: CLLocation!
    var musicScene = MusicScene()

    override func viewDidLoad() {
        readUserLocations()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        onLocationChange()
        locationLabel.textColor = UIColor.innocence()
    }

    @IBAction func nextLocation(sender: AnyObject) {
        locationIndex = (locationIndex + 1) % userLocations.count
        onLocationChange()
    }
    
    @IBAction func addLocation(sender: AnyObject) {
        nameTextBox.hidden = false
        addButton.hidden = true
        okButton.hidden = false
        nextButton.hidden = true
        nameTextBox.becomeFirstResponder()
    }
    
    @IBAction func acceptLocation(sender: AnyObject) {
        nameTextBox.hidden = true
        addButton.hidden = false
        nextButton.hidden = false
        okButton.hidden = true
        var locationString = "\(nameTextBox.text):\(here!.coordinate.latitude),\(here!.coordinate.longitude),5"
        userLocations.append(locationString)
        saveUserLocations()
        onLocationChange()
    }
    
    func getMusicScene() -> MusicScene {
        return musicScene
    }
    
    func readUserLocations() {
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        var path = paths.stringByAppendingPathComponent("locations.plist")
        var fileManager = NSFileManager.defaultManager()
        if (!(fileManager.fileExistsAtPath(path))) {
            var bundle : NSString = NSBundle.mainBundle().pathForResource("Data", ofType: "plist")!
            fileManager.copyItemAtPath(bundle, toPath: path, error:nil)
        }
        
        props = NSDictionary(contentsOfFile: path)?.mutableCopy() as NSDictionary
        
        
        userLocations = props?.valueForKey("Locations") as [String]
    }
    
    func saveUserLocations() {
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        var path = paths.stringByAppendingPathComponent("locations.plist")
        props?.setValue(userLocations, forKey: "Locations")
        props?.writeToFile(path, atomically: true)
    }
    
    
    func onLocationChange() {
        musicScene = MusicScene()
        updateLocation()
        closeWebSocket()
        openWebSocket()
        locationLabel.text = locationName
    }
    
    func updateLocation() {
        var locationDetails = userLocations[locationIndex]
        let split = locationDetails.rangeOfString(":")!.startIndex
        let name: String = locationDetails.substringWithRange(Range<String.Index>(start: locationDetails.startIndex, end: split))
        location = locationDetails.substringWithRange(Range<String.Index>(start: split.successor(), end: locationDetails.endIndex))
        locationName = name
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
    }
    
    func webSocket(webSocket: SRWebSocket!, didReceiveMessage message: AnyObject) {
        objc_sync_enter(self)
        self.musicScene.add(Gig(jsonText: message.description))
        objc_sync_exit(self)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        here = locations[0] as CLLocation
    }
    
    func webSocket(webSocket: SRWebSocket!, didFailWithError error: NSError) {
        println("Error: \(error.description)")
    }
    
    func webSocket(webSocket: SRWebSocket!, didCloseWithCode code: NSInteger, reason: NSString) {
        println("Close")
    }

}