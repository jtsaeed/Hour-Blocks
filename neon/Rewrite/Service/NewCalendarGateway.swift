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
}

struct NewCalendarGateway {
    
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
        let eventsPredicate = eventStore.predicateForEvents(withStart: date.toLocalTime().dateAtStartOf(.day),
                                                            end: date.toLocalTime().dateAtEndOf(.day),
                                                            calendars: eventStore.calendars(for: .event))
        
        return eventStore.events(matching: eventsPredicate)
    }
}
