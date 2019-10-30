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
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let todayStart = Calendar.current.date(bySetting: .hour, value: 0, of: yesterday)
        let todayEnd = Calendar.current.date(bySetting: .hour, value: 23, of: Date())
        let eventsPredicate = eventStore.predicateForEvents(withStart: todayStart!, end: todayEnd!, calendars: getAllCalendars())
        
		return importEvents(with: eventsPredicate, today: true)
    }
    
	func importEvents(with predicate: NSPredicate, today: Bool) -> [ImportedCalendarEvent] {
        var importedCalendarEvents = [ImportedCalendarEvent]()
		
        for storedEvent in eventStore.events(matching: predicate) {
            let importedCalendarEvent = ImportedCalendarEvent(from: storedEvent)
            
            if (isAllDay(event: importedCalendarEvent)) {
                allDayEvent = importedCalendarEvent
			} else {
				importedCalendarEvents.append(importedCalendarEvent)
			}
        }
        
        return importedCalendarEvents
    }
	
    /*
	private func getEnabledCalendars() -> [EKCalendar] {
		var enabledCalendars = [EKCalendar]()
		
		if let loadedEnabledCalenders = DataGateway.shared.loadEnabledCalendars() {
			for loadedEnabledCalender in loadedEnabledCalenders {
				if loadedEnabledCalender.value == true {
					if let enabledCalendar = eventStore.calendar(withIdentifier: loadedEnabledCalender.key) {
						enabledCalendars.append(enabledCalendar)
					}
				}
			}
			
			return enabledCalendars
		} else {
			return eventStore.calendars(for: EKEntityType.event)
		}
	}
 */
	
	func getAllCalendars() -> [EKCalendar] {
		return eventStore.calendars(for: .event)
	}
    
    func isAllDay(event: ImportedCalendarEvent) -> Bool {
        return event.startingHour == 0 && event.endingHour == 23
    }
}

struct ImportedCalendarEvent {
    
    let title: String
    
    var startingHour: Int
    var endingHour: Int
    
    var startingMinute: Int
    var endingMinute: Int
    
	init(from event: EKEvent) {
        title = event.title
        
		startingHour = Calendar.current.component(.hour, from: event.startDate)
		endingHour = Calendar.current.component(.hour, from: event.endDate)
        
        startingMinute = Calendar.current.component(.minute, from: event.startDate)
        endingMinute = Calendar.current.component(.minute, from: event.endDate)
		
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
        
        /*
        // Calibrate minutes
        if startingMinute
        
        if endingMinute > 0 && endingMinute < 15 {
            endingMinute = 15
        } else if endingMinute > 15 && endingMinute <= 30 {
            
        } else if endingMinute > 30 && endingMinute <= 45 {
            
        }
 */
    }
}
