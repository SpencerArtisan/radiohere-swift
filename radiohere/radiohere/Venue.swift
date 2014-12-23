//
//  Venue.swift
//  radiohere
//
//  Created by Spencer Ward on 22/12/2014.
//  Copyright (c) 2014 Spencer Ward. All rights reserved.
//

import Foundation

class Venue : NSObject {
    var name: String = ""
    var distance: String = ""
    
    init(gig: Gig) {
        self.name = gig.venue()
        self.distance = gig.distance()
    }
    
    override func isEqual(anObject: AnyObject?) -> Bool {
        return anObject is Venue && (anObject as Venue).name == name
    }
    
    func hashValue() -> Int {
        return name.hashValue
    }
    
}

