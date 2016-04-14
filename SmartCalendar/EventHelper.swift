//
//  EventHelper.swift
//  SmartCalendar
//
//  Created by Rafael Saraceni on 4/14/16.
//  Copyright © 2016 Rafael Saraceni. All rights reserved.
//

import Foundation
import EventKit

class EventHelper {
    
    static let EventStartDate = "EventStartDate"
    static let EventEndDate = "EventEndDate"
    static let EventTitle = "EventTitle"
    static let EventLocation = "EventLocation"
    
    static let OneHour = 2 * 60.0 * 60.0
    static let OneAndHalfHour = 1.5 * 2 * 60.0 * 60.0
    
    private static var eventStoreLocal: EKEventStore?
    static var eventStore: EKEventStore {
        
        get {
            if eventStoreLocal == nil {
                eventStoreLocal = EKEventStore()
            }
            
            return eventStoreLocal!
        }
        
    }
    static func addEvent(eventData: [String:AnyObject]) -> Bool {
        
        switch EKEventStore.authorizationStatusForEntityType(EKEntityType.Event) {
        case .Authorized:
            addToEventStore(eventData)
            return true
        case .NotDetermined:
            requestAccess(eventData)
            return false
        default:
            return false
        }
    }
    
    private static func requestAccess(eventData: [String:AnyObject]) {
        
        self.eventStore.requestAccessToEntityType(EKEntityType.Event, completion: {
            (granted, error) in
            if granted {
                self.addToEventStore(eventData)
            }
        })
        
    }
    
    private static func addToEventStore(eventData: [String:AnyObject]) {
        
        let event = EKEvent(eventStore: eventStore)
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        event.title = eventData[EventTitle] as? String ?? "New Event from Smart Calendar"
        event.startDate = eventData[EventStartDate] as? NSDate ?? NSDate().dateByAddingTimeInterval(OneHour)
        event.endDate = eventData[EventEndDate] as? NSDate ?? NSDate().dateByAddingTimeInterval(OneAndHalfHour)
        event.location = eventData[EventLocation] as? String
        
        do {
            try eventStore.saveEvent(event, span: EKSpan.ThisEvent)
            print("saved")
        } catch let specError as NSError {
            print("A specific error occurred: \(specError)")
        } catch {
            print("An error occurred")
        }
        
    }
    
    // MARK: - Decoding Helper Functions'
    
    static func decodeEventData(data: String) -> [String:String] {
        
        let params = data.componentsSeparatedByString("&")
        var paramsDictionary = [String:String]()
        for i in 0..<params.count {
            let keyParam = params[i].componentsSeparatedByString("=")
            let key = keyParam[0]
            let param = keyParam[1]
            paramsDictionary[key] = param
        }
        return paramsDictionary
        
    }
    
    static func decodeEventData(data: [String:String]) -> [String: AnyObject] {
        
        var result = [String: AnyObject]()
        
        for key in data.keys {
            
            switch(key) {
            case EventLocation, EventTitle:
                result[key] = data[key]
            case EventEndDate, EventStartDate:
                if let stringDate = data[key] {
                    result[key] = DateUtils.formatOSDate(stringDate)
                }
            default:
                break
            }
            
        }
        
        return result
    }
    
}










