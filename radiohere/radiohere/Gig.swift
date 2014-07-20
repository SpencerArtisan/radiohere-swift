//
//  Gig.swift
//  radiohere
//
//  Created by Spencer Ward on 15/06/2014.
//  Copyright (c) 2014 Spencer Ward. All rights reserved.
//

import Foundation

class Gig {
    var json: NSDictionary
    
    init(jsonText: NSString) {
        var data = jsonText.dataUsingEncoding(NSUTF8StringEncoding);
        json = NSJSONSerialization.JSONObjectWithData(data, options:    NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
    }
    
    func artist() -> String {
        return json["artist"] as String
    }
    
    func songkickUrl() -> String {
        return json["songkickUrl"] as String
    }
    
    func venue() -> String {
        return json["venueName"] as String
    }
    
    func distance() -> String {
        var distance = json["distance"] as Float
        return NSString(format: "%.1f", distance)
    }
    
    func nsDate() -> NSDate {
        var dateString = json["date"] as String
        return NSDate(dateString: dateString)
    }

    func date() -> String {
        return nsDate().format("dd MMM")
    }
    
    func hasTrack() -> Bool {
        return json["tracks"].count > 0
    }
    
    func tracks() -> Array<Track> {
        return (json["tracks"] as Array).map { Track(json: $0) }
    }
}