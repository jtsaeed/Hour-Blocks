//
//  NewCalendarGateway.swift
//  Hour Blocks
//
//  Created by James Saeed on 06/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import Foundation
import EventKit
import SwiftDate

protocol CalendarGatewayProtocol {
    
    func hasPermission() -> Bool
    func requestPermissions(completion: @escaping (_ granted: Bool) -> Void)
    func getEvents(for date: Date) -> [EKEvent]
    func initialiseEnabledCalendars() -> [String: Bool]
    func getAllCalendars() -> [EKCalendar]
}

/// The gateway service used to interface with EventKit.
class CalendarGateway: CalendarGatewayProtocol {
    
    private var eventStore = EKEventStore()
    
    /// Determines whether or not the user has granted calendar access permissions to the app.
    ///
    /// - Returns:
    /// Whether access is graned or not.
    func hasPermission() -> Bool {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        return status == EKAuthorizationStatus.authorized
    }
    
    /// Requests calendar access permissions for the app.
    ///
    /// - Parameters:
    ///   - completion: The callback function to be triggered when the user has chosen to grant access, providing a value on whether or not permission was granted.
    func requestPermissions(completion: @escaping (_ granted: Bool) -> Void) {
        eventStore.requestAccess(to: .event) { granted, error in
            self.eventStore = EKEventStore()
            completion(granted)
        }
    }
    
    /// Retrieves all calendar events on a given day for the enabled calendars.
    ///
    /// - Parameters:
    ///   - date: The day to match when querying calendar events from EventKit.
    ///
    /// - Returns:
    /// An array of calendar events.
    func getEvents(for date: Date) -> [EKEvent] {
        // Instances of Date are in UTC, so they need to be converted to local first to get the proper day start time
        // Then converted back to UTC because calendar events are in UTC
        let startDate = date.toLocalTime().dateAtStartOf(.day).toGlobalTime()
        let endDate = date.toLocalTime().dateAtEndOf(.day).toGlobalTime()
        
        let enabledCalendars = getEnabledCalendars()
        guard !enabledCalendars.isEmpty else { return [] }
        
        let eventsPredicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: enabledCalendars)
        return eventStore.events(matching: eventsPredicate)
    }
    
    /// Sets all of the user's calendars to be enabled; called when there is no `enabledCalendars` value present in UserDefaults.
    func initialiseEnabledCalendars() -> [String: Bool] {
        var enabledCalendars = [String: Bool]()
        
        let calendarIdentifiers = getAllCalendars().map { $0.calendarIdentifier }
        for identifier in calendarIdentifiers {
            enabledCalendars[identifier] = true
        }
        
        UserDefaults.standard.set(enabledCalendars, forKey: "enabledCalendars")
        
        return enabledCalendars
    }
    
    /// Retrieves all of the user's calendars.
    ///
    /// - Returns:
    /// An array of calendars.
    func getAllCalendars() -> [EKCalendar] {
        return eventStore.calendars(for: .event)
    }
    
    /// Retrieves all of the user's enabled calendars.
    ///
    /// - Returns:
    /// An array of calendars.
    private func getEnabledCalendars() -> [EKCalendar] {
        if let userCalendars = UserDefaults.standard.dictionary(forKey: "enabledCalendars") as? [String: Bool] {
            let enabledCalendars = getAllCalendars().compactMap { calendar in
                userCalendars[calendar.calendarIdentifier] == true ? calendar : nil
            }
            
            return enabledCalendars
        } else {
            return getAllCalendars()
        }
    }
}
