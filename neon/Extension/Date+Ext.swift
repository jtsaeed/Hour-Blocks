//
//  Date+Ext.swift
//  neon
//
//  Created by James Saeed on 07/02/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import Foundation
import SwiftDate

extension Date {
    
    func getFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E d MMM"
        
        return dateFormatter.string(from: self).uppercased()
    }
    
    func getRelativeDateToToday() -> String {
        if Calendar.current.isDateInToday(self) {
            return "Today"
        } else if self.isInPast {
            return "The Past"
        } else if Calendar.current.isDateInTomorrow(self) {
            return "Tomorrow"
        } else if self.isInRange(date: Date(), and: (Date() + 7.days)) {
            return "This Week"
        } else if self.isInside(date: Date(), granularity: .month) {
            return "This Month"
        } else {
            return "The Future"
        }
    }
    
    func getMonthAndYear() -> String {
        return "\(self.monthName(.default)) \(self.year)"
    }
    
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
}

extension Date: Identifiable {
    
    public var id: String {
        return UUID().uuidString
    }
}
