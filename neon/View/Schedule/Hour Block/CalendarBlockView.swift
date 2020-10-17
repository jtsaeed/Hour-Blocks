//
//  CalendarBlockView.swift
//  Hour Blocks
//
//  Created by James Saeed on 06/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI
import EventKit

/// A Card based view for displaying a Calendar event.
struct CalendarBlockView: View {
    
    /// A UserDefaults property determining what hour format to use when displaying times
    @AppStorage("timeFormat") private var timeFormatValue: Int = 1
    
    private let event: EKEvent
    
    /// Creates an instance of HourBlockView.
    ///
    /// - Parameters:
    ///   - event: The event to be displayed.
    init(for event: EKEvent) {
        self.event = event
    }
    
    var body: some View {
        Card {
            HStack {
                CardLabels(title: event.title,
                           subtitle: getSubtitle())
                Spacer()
                HourBlockIcon(name: "event")
            }
        }.padding(.horizontal, 24)
    }
    
    /// Determines the properly formatted subtitle for the calendar event.
    ///
    /// - Returns:
    /// A formatted subtitle string
    private func getSubtitle() -> String {
        if event.isAllDay {
            return "ALL DAY"
        } else {
            return "\(event.startDate.getFullFormattedTime(usingMilitaryTime: isUsingMilitaryTime())) TO \(event.endDate.getFullFormattedTime(usingMilitaryTime: isUsingMilitaryTime()))"
        }
    }
    
    /// Determines whether or not to use military time based on user preferences
    ///
    /// - Returns:
    /// A boolean on whether or not to use military time
    private func isUsingMilitaryTime() -> Bool {
        return (timeFormatValue == 0 && !UtilGateway.shared.isSystemClock12h()) || timeFormatValue == 2
    }
}
