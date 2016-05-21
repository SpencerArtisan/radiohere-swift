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

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var nameTextBox: UITextField!
    @IBOutlet weak var locationLabel: UILabel!

    var location: String?
    var locationName: String?
    var props: NSDictionary?
    var userLocations: [String] = []
    var locationIndex = 0
    var locationManager = CLLocationManager()
    var here: CLLocation!
    var musicScene = MusicScene()

    func setRelated(related: LocationController) {
        location = related.location
        locationName = related.locationName
        locationIndex = related.locationIndex
        socket = related.socket
        props = related.props
        userLocations = related.userLocations
        locationManager = related.locationManager
        musicScene = related.musicScene
        here = related.here
        if (deleteButton != nil) {
            deleteButton.hidden = related.deleteButton.hidden
        }
        if (locationLabel != nil) {
            locationLabel.hidden = related.locationLabel.hidden
            locationLabel.text = locationName
        }
    }
    
    override func viewDidLoad() {
        readUserLocations()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        onLocationChange()
    }

    @IBAction func nextLocation(sender: AnyObject) {
        locationIndex = (locationIndex + 1) % userLocations.count
        onLocationChange()
    }
    
    @IBAction func deleteLocation(sender: AnyObject) {
        userLocations.removeAtIndex(locationIndex)
        saveUserLocations()
        if locationIndex > 0 {
            locationIndex--
        }
        onLocationChange()
    }
    
    @IBAction func addLocation(sender: AnyObject) {
        nameTextBox.text = ""
        editMode(true)
    }
    
    @IBAction func hitEnter(sender: AnyObject) {
        acceptLocation(sender)
    }
    
    @IBAction func acceptLocation(sender: AnyObject) {
        if (!nameTextBox.text!.isEmpty) {
            editMode(false)
            var locationString = "\(nameTextBox.text!):\(here!.coordinate.latitude),\(here!.coordinate.longitude),10"
            userLocations.append(locationString)
            saveUserLocations()
            locationIndex = userLocations.count - 1
            onLocationChange()
        }
    }

    @IBAction func cancelAddLocation(sender: AnyObject) {
        editMode(false)
    }
    
    func editMode(isEditMode: Bool) {
        nameTextBox.hidden = !isEditMode
        addButton.hidden = isEditMode
        okButton.hidden = !isEditMode
        nextButton.hidden = isEditMode
        deleteButton.hidden = isEditMode
        cancelButton.hidden = !isEditMode
        if (isEditMode) {
            nameTextBox.becomeFirstResponder()
        } else {
            nameTextBox.resignFirstResponder()
        }
    }
    
    func getMusicScene() -> MusicScene {
        return musicScene
    }
    
    func readUserLocations() {
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        var path = paths.stringByAppendingPathComponent("locations.plist")
        var fileManager = NSFileManager.defaultManager()
        if (!(fileManager.fileExistsAtPath(path))) {
            var bundle : NSString = NSBundle.mainBundle().pathForResource("Data", ofType: "plist")!
            try! fileManager.copyItemAtPath(bundle as String, toPath: path as String)
        }
        
        props = NSDictionary(contentsOfFile: path)?.mutableCopy() as! NSDictionary
        
        userLocations = props?.valueForKey("Locations") as! [String]
    }
    
    func saveUserLocations() {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        let path = paths.stringByAppendingPathComponent("locations.plist")
        props?.setValue(userLocations, forKey: "Locations")
        props?.writeToFile(path, atomically: true)
    }
    
    func onLocationChange() {
        musicScene = MusicScene()
        updateLocation()
        closeWebSocket()
        openWebSocket()
        updateLabel()
        deleteButton.hidden = (userLocations.count < 1)
    }
    
    func updateLabel() {
        locationLabel.text = locationName
        if (here != nil) {
            addButton.hidden = false
        }
        deleteButton.hidden = (userLocations.count < 1)
    }
    
    func updateLocation() {
        let locationDetails = userLocations[locationIndex]
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
        print("Socket Open!")
        socket.send(location)
    }
    
    func webSocket(webSocket: SRWebSocket!, didReceiveMessage message: AnyObject) {
        objc_sync_enter(self)
        self.musicScene.add(Gig(jsonText: message.description))
        objc_sync_exit(self)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        here = locations[0] as CLLocation
        addButton.hidden = false
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
    }

    
    func webSocket(webSocket: SRWebSocket!, didFailWithError error: NSError) {
        print("Error: \(error.description)")
    }
    
    func webSocket(webSocket: SRWebSocket!, didCloseWithCode code: NSInteger, reason: NSString) {
        print("Close")
    }

}