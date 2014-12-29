//
//  NSDateExt.swift
//  radiohere
//
//  Created by Spencer Ward on 15/06/2014.
//  Copyright (c) 2014 Spencer Ward. All rights reserved.
//

import Foundation
import CoreLocation

let formatter: NSDateFormatter = NSDateFormatter()

// For simulation mode
//extension CLLocationManager {
//    func startUpdatingLocation() {
//        var fakeLocation = CLLocation(latitude: 51.484225, longitude: -0.022034)
//        self.delegate.locationManager!(self, didUpdateLocations: [fakeLocation])
//    }
//}

extension UIColor {
    class func fromRGB(r:Double, g: Double, b: Double, a: Double) -> UIColor {
        return UIColor(red: CGFloat(r/255), green: CGFloat(g/255), blue: CGFloat(b/255), alpha: CGFloat(a))
    }
    
    class func innocence(a: Double = 1) -> UIColor {
        return fromRGB(217, g: 206, b: 178, a: a)
    }
    
    class func kindGiant(a: Double = 1) -> UIColor {
        return fromRGB(148, g: 140, b: 117, a: a)
    }
    
    class func bond(a: Double = 1) -> UIColor {
        return fromRGB(213, g: 222, b: 217, a: a)
    }
    
    class func pachyderm(a: Double = 1) -> UIColor {
        return fromRGB(122, g: 106, b: 83, a: a)
    }
    
    class func forever(a: Double = 1) -> UIColor {
        return fromRGB(153, g: 178, b: 183, a: a)
    }
}

extension NSDate {
    convenience
        init(dateString:String) {
            let dateStringFormatter = NSDateFormatter()
            dateStringFormatter.dateFormat = "yyyy-MM-dd"
            dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            let d = dateStringFormatter.dateFromString(dateString)
            self.init(timeInterval:0, sinceDate:d!)
    }
    
    func format(s:String) -> String {
        formatter.dateFormat = s
        return formatter.stringFromDate(self)
    }
    
    func format(date: NSDateFormatterStyle = .NoStyle, time: NSDateFormatterStyle = .NoStyle) -> String {
        formatter.dateFormat = nil;
        formatter.timeStyle = time;
        formatter.dateStyle = date;
        return formatter.stringFromDate(self)
    }
    
    func add(components: NSDateComponents) -> NSDate {
        let cal = NSCalendar.currentCalendar()
        return cal.dateByAddingComponents(components, toDate: self, options: nil)!
    }
    
    func addMonth(months: NSInteger) -> NSDate {
        var components = NSDateComponents()
        components.month = months
        return self.add(components)
    }
    
    func subtract(components: NSDateComponents) -> NSDate {
        
        func negateIfNeeded(i: NSInteger) -> NSInteger {
            return -i
        }
        
        components.year         = negateIfNeeded(components.year)
        components.month        = negateIfNeeded(components.month)
        components.weekOfYear   = negateIfNeeded(components.weekOfYear)
        components.day          = negateIfNeeded(components.day)
        components.hour         = negateIfNeeded(components.hour)
        components.minute       = negateIfNeeded(components.minute)
        components.second       = negateIfNeeded(components.second)
        components.nanosecond   = negateIfNeeded(components.nanosecond)
        return self.add(components)
    }
}

func + (left: NSDate, right:NSTimeInterval) -> NSDate {
    return left.dateByAddingTimeInterval(right)
}

func + (left: NSDate, right:NSDateComponents) -> NSDate {
    return left.add(right);
}

func - (left: NSDate, right:NSTimeInterval) -> NSDate {
    return left.dateByAddingTimeInterval(-right)
}

func - (left: NSDate, right:NSDateComponents) -> NSDate {
    return left.subtract(right);
}

extension Int {
    
    func seconds() -> NSDateComponents {
        var components = NSDateComponents()
        components.second = self
        return components
    }
    
    func minutes() -> NSDateComponents {
        var components = NSDateComponents()
        components.minute = self
        return components
    }
    
    func hour() -> NSDateComponents {
        var components = NSDateComponents()
        components.hour = self
        return components
    }
    
    func days() -> NSDateComponents {
        var components = NSDateComponents()
        components.day = self
        return components
    }
    
    func weeks() -> NSDateComponents {
        var components = NSDateComponents()
        components.weekOfYear = self
        return components
    }
    
    func month() -> NSDateComponents {
        var components = NSDateComponents()
        components.month = self
        return components
    }
    
    func years() -> NSDateComponents {
        var components = NSDateComponents()
        components.year = self
        return components
    }
    
}

