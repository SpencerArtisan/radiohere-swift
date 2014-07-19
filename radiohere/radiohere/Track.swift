//
//  gig.swift
//  radiohere
//
//  Created by Spencer Ward on 15/06/2014.
//  Copyright (c) 2014 Spencer Ward. All rights reserved.
//

import Foundation

class Track {
    var json: NSDictionary
    
    init(json: NSDictionary) {
        self.json = json
    }
    
    func streamUrl() -> NSURL {
        return NSURL.URLWithString(json["streamUrl"] as NSString)
    }
    
    func name() -> NSString {
        return json["name"] as NSString
    }
}