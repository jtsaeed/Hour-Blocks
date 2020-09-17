//
//  MockCalendarGateway.swift
//  Hour Blocks
//
//  Created by James Saeed on 12/08/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import Foundation
import EventKit

struct MockCalendarGateway: CalendarGatewayProtocol {
    
    func hasPermission() -> Bool {
        return false
    }
    
    func handlePermissions(completion: @escaping (_ granted: Bool) -> Void) {
        completion(true)
    }
    
    func getEvents(for date: Date) -> [EKEvent] {
        return [EKEvent]()
    }
    
    func initialiseEnabledCalendars() -> [String : Bool] {
        return [String: Bool]()
    }
    
    func getCalendarName(for identifier: String) -> String {
        return ""
    }
    
    func getAllCalendars() -> [EKCalendar] {
        return [EKCalendar]()
    }
}
