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
    var gigsByDate = Dictionary<NSDate, NSMutableArray>()
    var gigsByVenue = Dictionary<Venue, NSMutableArray>()
    
    func add(gig: Gig) {
        if gig.hasTrack() {
            self.allGigs.append(gig)

            var gigs : NSMutableArray
            
            if (gigsByDate[gig.nsDate()] != nil) {
                gigs = gigsByDate[gig.nsDate()]!
                gigs.addObject(gig)
                gigsByDate[gig.nsDate()] = gigs
            } else {
                gigs = NSMutableArray()
                gigs.addObject(gig)
                gigsByDate[gig.nsDate()] = gigs
            }

            let venue = Venue(gig: gig as Gig)
            if (gigsByVenue[venue] != nil) {
                gigs = gigsByVenue[venue]!
                gigs.addObject(gig)
                gigsByVenue[venue] = gigs
            } else {
                gigs = NSMutableArray()
                gigs.addObject(gig)
                gigsByVenue[venue] = gigs
            }
        }
    }
    
    func hasGigOn(date: NSDate) -> Bool {
        return self.gigsByDate[date] != nil
    }
    
    func getGigsOn(date: NSDate) -> [Gig] {
        return self.gigsByDate[date]! as AnyObject as! [Gig]
    }
    
    func getGigsAt(venue: Venue) -> [Gig] {
        var gigs = self.gigsByVenue[venue]! as AnyObject as! [Gig]
        gigs.sort { (a:Gig, b:Gig) -> Bool in
            return a.nsDate().compare(b.nsDate()) == NSComparisonResult.OrderedAscending
        }
        return gigs
    }
    
    func getGigsAt(venueName: String) -> [Gig] {
        return getGigsAt(Venue(venueName: venueName))
    }
    
    func getVenues() -> [Venue] {
        var venues = Array(self.gigsByVenue.keys)
        venues.sortInPlace({ (a:Venue, b:Venue) -> Bool in
            return (a.distance as NSString).floatValue < (b.distance as NSString).floatValue
        })
        return venues
    }
}