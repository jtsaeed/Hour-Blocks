//
//  CalendarGateway.swift
//  neon
//
//  Created by James Saeed on 25/02/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import Foundation
import EventKit

class CalendarGateway {
    
    static let shared = CalendarGateway()
    
    let eventStore = EKEventStore()
    
    func hasPermission() -> Bool {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        return status == EKAuthorizationStatus.authorized
    }
    
    func handlePermissions() {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        
        if status == EKAuthorizationStatus.notDetermined {
            eventStore.requestAccess(to: .event) { (granted, error) in }
        }
    }
    
    func importTodaysEvents() -> [ImportedCalendarEvent] {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let todayStart = Calendar.current.date(bySetting: .hour, value: 0, of: yesterday)
        let todayEnd = Calendar.current.date(bySetting: .hour, value: 23, of: Date())
        let eventsPredicate = eventStore.predicateForEvents(withStart: todayStart!, end: todayEnd!, calendars: eventStore.calendars(for: EKEntityType.event))
        
        return importEvents(with: eventsPredicate)
    }
    
    func importTomorrowsEvents() -> [ImportedCalendarEvent] {
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        let tomorrowStart = Calendar.current.date(bySetting: .hour, value: 0, of: Date())
        let tomorrowEnd = Calendar.current.date(bySetting: .hour, value: 23, of: tomorrow)
        let eventsPredicate = eventStore.predicateForEvents(withStart: tomorrowStart!, end: tomorrowEnd!, calendars: eventStore.calendars(for: EKEntityType.event))
        
        return importEvents(with: eventsPredicate)
    }
    
    func importEvents(with predicate: NSPredicate) -> [ImportedCalendarEvent] {
        var importedCalendarEvents = [ImportedCalendarEvent]()
        
        for storedEvent in eventStore.events(matching: predicate) {
            let importedCalendarEvent = ImportedCalendarEvent(from: storedEvent)
            
            if (!isAllDay(event: importedCalendarEvent)) {
                importedCalendarEvents.append(importedCalendarEvent)
            }
        }
        
        return importedCalendarEvents
    }
    
    func isAllDay(event: ImportedCalendarEvent) -> Bool {
        return event.startTime == 0 && event.endTime == 22
    }
}

struct ImportedCalendarEvent {
    
    let title: String
    let startTime: Int
    let endTime: Int
    
    init(from event: EKEvent) {
        title = event.title
        startTime = Calendar.current.component(.hour, from: event.startDate)
        endTime = Calendar.current.component(.hour, from: event.endDate) - 1
    }
}
