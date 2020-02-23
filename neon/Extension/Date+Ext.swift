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
    
    func getFormattedTime(militaryTime: Bool) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = militaryTime ? "HH:00" : "ha"
        
        return dateFormatter.string(from: self).uppercased()
    }
    
    func getRelativeDateToToday() -> String {
        if Calendar.current.isDateInToday(self) {
            return NSLocalizedString("Today", comment: "")
        } else if self.isInPast {
            return NSLocalizedString("The Past", comment: "")
        } else if Calendar.current.isDateInTomorrow(self) {
            return NSLocalizedString("Tomorrow", comment: "")
        } else if self.isInRange(date: Date(), and: (Date() + 7.days)) {
            return NSLocalizedString("This Week", comment: "")
        } else if self.isInside(date: Date(), granularity: .month) {
            return NSLocalizedString("This Month", comment: "")
        } else {
            return NSLocalizedString("The Future", comment: "")
        }
    }
    
    func getMonthAndYear() -> String {
        return "\(self.monthName(.default).capitalized) \(self.year)"
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
