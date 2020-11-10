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
    
    /// Converts the date into the formatted form of `E d MMM`.
    ///
    /// - Returns:
    /// The formatted date string.
    func getFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E d MMM"
        
        return dateFormatter.string(from: self).uppercased()
    }
    
    /// Converts the date into the formatted form of either `HH:mm` or `h:mma` depending on whether or not military time is being used.
    ///
    /// - Parameters:
    ///   - date: The day to match when querying calendar events from EventKit.
    ///
    /// - Returns:
    /// The formatted date string.
    func getFullFormattedTime(usingMilitaryTime: Bool) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = usingMilitaryTime ? "HH:mm" : "h:mma"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        return dateFormatter.string(from: self).uppercased()
    }
    
    /// Converts the date to UTC time.
    ///
    /// - Returns:
    /// A UTC adjusted date object.
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    /// Converts the date to local time.
    ///
    /// - Returns:
    /// A local-time adjusted date object.
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
}
