//
//  SettingsStore.swift
//  neon
//
//  Created by James Saeed on 06/11/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import Foundation
import Combine
import UIKit

class SettingsViewModel: ObservableObject {
    
    @Published var userCalendars: [UserCalendar]
    @Published var other: OtherSettings
    
    init() {
        userCalendars = DataGateway.shared.getUserCalendars()
        
        // Load other settings
        if let otherSettings = DataGateway.shared.getOtherSettings() {
            other = otherSettings
        } else {
            other = OtherSettings(timeFormat: 1,
                                  reminderTimer: 1,
                                  autoCaps: 0,
                                  dayStart: 2)
            DataGateway.shared.saveOtherSettings(other)
        }
    }
    
    func toggleCalendar(for identifier: String) {
        if let index = userCalendars.firstIndex(where: { $0.identifier == identifier }) {
            userCalendars[index].enabled.toggle()
            DataGateway.shared.modifyUserCalendar(userCalendar: userCalendars[index])
        } else {
            let userCalendar = UserCalendar(identifier: identifier, enabled: false)
            DataGateway.shared.saveUserCalendar(userCalendar)
        }
    }
    
    func setTimeFormat(to value: Int) {
        other.timeFormat = value
        DataGateway.shared.modifyOtherSettings(set: value, forKey: "timeFormat")
    }
    
    func setReminderTimer(to value: Int) {
        other.reminderTimer = value
        DataGateway.shared.modifyOtherSettings(set: value, forKey: "reminderTimer")
    }
    
    func setAutoCaps(to value: Int) {
        other.autoCaps = value
        DataGateway.shared.modifyOtherSettings(set: value, forKey: "autoCaps")
    }
    
    func setDayStart(to value: Int) {
        other.dayStart = value
        DataGateway.shared.modifyOtherSettings(set: value, forKey: "dayStart")
    }
    
    func set(icon: AppIconKey) {
        var iconName: String? = nil
        
        if icon == .pro {
            iconName = "icon_pro"
        }
        
        if icon == .dark {
            iconName = "icon_dark"
        }
        
        UIApplication.shared.setAlternateIconName(iconName) { error in
            if let error = error { print(error.localizedDescription) }
        }
    }
}

enum AppIconKey: String {
    
    case original
    case pro = "icon_pro"
    case dark = "icon_dark"
}
