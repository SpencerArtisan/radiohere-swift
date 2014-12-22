//
//  MusicScene.swift
//  radiohere
//
//  Created by Spencer Ward on 22/12/2014.
//  Copyright (c) 2014 Spencer Ward. All rights reserved.
//

import Foundation

class MusicScene {
    var allGigs: [Gig] = []
    var tableData = Dictionary<NSDate, NSMutableArray>()

    
    func add(gig: Gig) {
        if gig.hasTrack() {
            self.allGigs.append(gig)

            var gigs : NSMutableArray
            if (tableData[gig.nsDate()] != nil) {
                gigs = tableData[gig.nsDate()]!
                gigs.addObject(gig)
                tableData[gig.nsDate()] = gigs
            } else {
                gigs = NSMutableArray()
                gigs.addObject(gig)
                tableData[gig.nsDate()] = gigs
            }
        }
    }
    
    func hasGigOn(date: NSDate) -> Bool {
        return self.tableData[date] != nil
    }
    
    
    func getVenues() -> [Venue] {
        var venues2 = self.allGigs.reduce(NSMutableArray()) {(venues, gig) in
            var venue = Venue(gig: gig as Gig)
            if (!venues.containsObject(venue)) {
                venues.addObject(venue)
            }
            return venues
        }
        var venues3 = venues2 as AnyObject as [Venue]
        venues3.sort({ (a:Venue, b:Venue) -> Bool in
            return (a.distance as NSString).floatValue < (b.distance as NSString).floatValue
        })
        return venues3
    }

}