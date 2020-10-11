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
    
    func getFullFormattedTime(militaryTime: Bool) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = militaryTime ? "HH:mm" : "h:mma"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        return dateFormatter.string(from: self).uppercased()
    }
    
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
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
