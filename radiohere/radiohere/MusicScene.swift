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

            var venue = Venue(gig: gig as Gig)
            if (gigsByVenue[venue] != nil) {
                println("Adding matched venue" + venue.name)
                gigs = gigsByVenue[venue]!
                gigs.addObject(gig)
                gigsByVenue[venue] = gigs
            } else {
                println("Adding new venue" + venue.name)
                gigs = NSMutableArray()
                gigs.addObject(gig)
                gigsByVenue[venue] = gigs
            }
        
        }
    }
    
    func hasGigOn(date: NSDate) -> Bool {
        return self.gigsByDate[date] != nil
    }
    
    func getGigsOn(date: NSDate) -> NSMutableArray {
        return self.gigsByDate[date]!
    }
    
    func getGigsAt(venue: Venue) -> NSMutableArray {
        return self.gigsByVenue[venue]!
    }
    
    func getVenues() -> [Venue] {
        var venues = self.gigsByVenue.keys.array
        venues.sort({ (a:Venue, b:Venue) -> Bool in
            return (a.distance as NSString).floatValue < (b.distance as NSString).floatValue
        })
        return venues
    }
}