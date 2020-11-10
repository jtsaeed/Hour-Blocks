//
//  CalendarOptionsViewModel.swift
//  Hour Blocks
//
//  Created by James Saeed on 22/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import Foundation
import EventKit

/// The view model for the CalendarOptionsView.
class CalendarOptionsViewModel: ObservableObject {
    
    private let calendarGateway: CalendarGatewayProtocol
    
    @Published private(set) var allCalendars = [EKCalendar]()
    @Published private(set) var enabledCalendars = [String: Bool]()
    
    /// Creates an instance of the CalendarOptionsViewModel and then loads the user's calendars.
    ///
    /// - Parameters:
    ///   - calendarGateway: The calendar gateway instance used to interface with EventKit. By default, this is set to an instance of CalendarGateway.
    init(calendarGateway: CalendarGatewayProtocol = CalendarGateway()) {
        self.calendarGateway = calendarGateway
        
        loadCalendars()
    }
    
    /// Determines whether or not the user has granted calendar access permissions to the app.
    ///
    /// - Returns:
    /// Whether access is graned or not.
    func calendarAccessGranted() -> Bool {
        return calendarGateway.hasPermission()
    }
    
    /// Loads all of the users available calendars, and loads which ones are enabled to be synced with the app.
    func loadCalendars() {
        allCalendars = calendarGateway.getAllCalendars()
        
        enabledCalendars = UserDefaults.standard.dictionary(forKey: "enabledCalendars") as? [String: Bool] ?? calendarGateway.initialiseEnabledCalendars()
    }
    
    /// Updates the enabled status of a specific user calendar.
    ///
    /// - Parameters:
    ///   - identifier: The unique identifier of the calendar to be updated.
    ///   - value: Whether or not to set the calendar as enabled to be sync with the app.
    func updateCalendar(for identifier: String, with value: Bool) {
        enabledCalendars[identifier] = value
        
        UserDefaults.standard.set(enabledCalendars, forKey: "enabledCalendars")
        
        NotificationCenter.default.post(name: Notification.Name("RefreshSchedule"), object: nil)
    }
}
