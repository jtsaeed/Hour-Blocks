//
//  SettingsStore.swift
//  neon
//
//  Created by James Saeed on 06/11/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import Foundation
import Combine

class SettingsStore: ObservableObject {
    
    @Published var enabledCalendars: [String: Bool] {
        didSet {
            UserDefaults.standard.set(enabledCalendars, forKey: "enabledCalendars")
        }
    }
    
    @Published var other: [String: Int] {
        didSet {
            UserDefaults.standard.set(other, forKey: "otherSettings")
        }
    }
    
    init() {
        enabledCalendars = DataGateway.shared.loadEnabledCalendars()
        other = DataGateway.shared.loadOtherSettings()
    }
    
    func toggleCalendar(for identifier: String, to status: Bool) {
        enabledCalendars[identifier] = status
    }
    
    func set(_ settingsKey: OtherSettingsKey, to value: Int) {
        other[settingsKey.rawValue] = value
    }
}

enum OtherSettingsKey: String {
    
    case scheduleBlocksStyle = "blocksStyle"
    case reminderTimer = "reminderTimer"
    case autocapitalisation = "autoCaps"
}
