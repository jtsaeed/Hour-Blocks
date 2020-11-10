//
//  UserPreference.swift
//  Hour Blocks
//
//  Created by James Saeed on 30/10/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import Foundation

enum UserPreference: String {
    
    case reminders, dayStart, timeFormat, autoCaps
    
    var key: String {
        return self.rawValue
    }
    
    var defaultValue: Int {
        switch self {
        case .reminders, .autoCaps: return 0
        case .timeFormat: return 1
        case .dayStart: return 2
        }
    }
    
    var title: String {
        switch self {
        case .reminders: return "Reminders"
        case .dayStart: return "Day Start"
        case .timeFormat: return "Time Format"
        case .autoCaps: return "Automatic Capitalization"
        }
    }
    
    var description: String {
        switch self {
        case .reminders: return "Enable reminders for upcoming Hour Blocks (changes only applied to new Hour Blocks)"
        case .dayStart: return "Change the time (am) your Schedule starts in Hour Blocks"
        case .timeFormat: return "Change the time format used throughout Hour Blocks"
        case .autoCaps: return "Would you like the titles of blocks to be automatically capitalized?"
        }
    }
    
    var options: [String] {
        switch self {
        case .reminders, .autoCaps: return ["Yes", "No"]
        case .dayStart: return ["12", "5", "6", "7", "8"]
        case .timeFormat: return ["System", "12h", "24h"]
        }
    }
}
