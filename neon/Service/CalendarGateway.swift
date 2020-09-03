//
//  NewCalendarGateway.swift
//  Hour Blocks
//
//  Created by James Saeed on 06/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import Foundation
import EventKit

protocol CalendarGatewayProtocol {
    
    func hasPermission() -> Bool
    func handlePermissions(completion: @escaping () -> Void)
    func getEvents(for date: Date) -> [EKEvent]
    func initialiseEnabledCalendars() -> [String: Bool]
    func getCalendarName(for identifier: String) -> String
    func getAllCalendars() -> [EKCalendar]
}

struct CalendarGateway: CalendarGatewayProtocol {
    
    let eventStore = EKEventStore()
    
    func hasPermission() -> Bool {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        return status == EKAuthorizationStatus.authorized
    }
    
    func handlePermissions(completion: @escaping () -> Void) {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        
        if status == EKAuthorizationStatus.notDetermined {
            eventStore.requestAccess(to: .event) { granted, error in
                completion()
            }
        }
    }
    
    func getEvents(for date: Date) -> [EKEvent] {
        let startDate = date.toLocalTime().dateAtStartOf(.day)
        
        let eventsPredicate = eventStore.predicateForEvents(withStart: date.toLocalTime().dateAtStartOf(.day),
                                                            end: date.toLocalTime().dateAtEndOf(.day),
                                                            calendars: getEnabledCalendars())
        
        return eventStore.events(matching: eventsPredicate).filter { event in
            !event.isAllDay || (event.isAllDay && event.endDate.toLocalTime().day == startDate.day)
        }
    }
    
    func initialiseEnabledCalendars() -> [String: Bool] {
        var enabledCalendars = [String: Bool]()
        
        let calendarIdentifiers = getAllCalendars().map { $0.calendarIdentifier }
        for identifier in calendarIdentifiers {
            enabledCalendars[identifier] = true
        }
        
        UserDefaults.standard.set(enabledCalendars, forKey: "enabledCalendars")
        
        return enabledCalendars
    }
    
    func getCalendarName(for identifier: String) -> String {
        return eventStore.calendar(withIdentifier: identifier)?.title ?? "Unknown Calendar Title"
    }
    
    func getAllCalendars() -> [EKCalendar] {
        return eventStore.calendars(for: .event)
    }
    
    private func getEnabledCalendars() -> [EKCalendar] {
        if let userCalendars = UserDefaults.standard.dictionary(forKey: "enabledCalendars") as? [String: Bool] {
            return getAllCalendars().compactMap { calendar in
                if userCalendars[calendar.calendarIdentifier] == true {
                    return calendar
                } else {
                    return nil
                }
            }
        } else {
            return getAllCalendars()
        }
    }
}
