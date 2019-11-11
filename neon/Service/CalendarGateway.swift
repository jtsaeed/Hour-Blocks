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
	
	var allDayEvent: ImportedCalendarEvent?
    
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
        var importedCalendarEvents = [ImportedCalendarEvent]()
        
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let todayStart = Calendar.current.date(bySetting: .hour, value: 0, of: yesterday)
        let todayEnd = Calendar.current.date(bySetting: .hour, value: 23, of: Date())
        let eventsPredicate = eventStore.predicateForEvents(withStart: todayStart!, end: todayEnd!, calendars: getEnabledCalendars())
        
        for storedEvent in eventStore.events(matching: eventsPredicate) {
            let importedCalendarEvent = ImportedCalendarEvent(from: storedEvent)
            
            if (storedEvent.isAllDay) {
                allDayEvent = importedCalendarEvent
            } else {
                importedCalendarEvents.append(importedCalendarEvent)
            }
        }
        
        return importedCalendarEvents
    }
    
    func importFutureEvents() -> [EKEvent] {
        let todayEnd = Calendar.current.date(bySetting: .hour, value: 23, of: Date())
        let yearEnd = Calendar.current.date(byAdding: .month, value: 1, to: todayEnd!)
        let eventsPredicate = eventStore.predicateForEvents(withStart: todayEnd!, end: yearEnd!, calendars: getEnabledCalendars())
        
        return eventStore.events(matching: eventsPredicate)
    }
	
	private func getEnabledCalendars() -> [EKCalendar] {
		var enabledCalendars = [EKCalendar]()
		
        for loadedEnabledCalender in DataGateway.shared.loadEnabledCalendars() {
            if loadedEnabledCalender.value == true {
                if let enabledCalendar = eventStore.calendar(withIdentifier: loadedEnabledCalender.key) {
                    enabledCalendars.append(enabledCalendar)
                }
            }
        }
        
        return enabledCalendars
	}
	
	func getAllCalendars() -> [EKCalendar] {
		return eventStore.calendars(for: .event)
	}
}

struct ImportedCalendarEvent {
    
    let title: String
    let date: Date
    
    var startingHour: Int
    var endingHour: Int
    
	init(from event: EKEvent) {
        title = event.title
        date = event.startDate
        
		startingHour = Calendar.current.component(.hour, from: event.startDate)
		endingHour = Calendar.current.component(.hour, from: event.endDate)
		
        // Calibrate hours
        if endingHour <= Calendar.current.component(.hour, from: Date()) {
            startingHour = 0
            endingHour = 0
        } else if startingHour > Calendar.current.component(.hour, from: event.endDate) {
            endingHour = 23
        } else if startingHour == Calendar.current.component(.hour, from: event.endDate) {
            endingHour = startingHour
        } else {
            if Calendar.current.component(.minute, from: event.endDate) == 0 {
                endingHour = Calendar.current.component(.hour, from: event.endDate) - 1
            } else {
                endingHour = Calendar.current.component(.hour, from: event.endDate)
            }
        }
    }
}
