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
        var urlString = json["streamUrl"] as! NSString
        var url = NSURL(string: urlString as String)!
        return url
    }
    
    func name() -> NSString {
        return json["name"] as! NSString
    }
}