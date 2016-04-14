//
//  DateUtils.swift
//  SmartCalendar
//
//  Created by Rafael Saraceni on 4/14/16.
//  Copyright © 2016 Rafael Saraceni. All rights reserved.
//

import Foundation

class DateUtils {
    
    
    static func getDefaultFormatWithTime(date: NSDate) -> String {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        return dateFormatter.stringFromDate(date)
        
    }
    
    static func formatOSDate(date: String) -> NSDate? {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        return dateFormatter.dateFromString(date)
        
    }
    
}
