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

enum OtherSettingsKey: String {
    
    case timeFormat
    case reminderTimer
    case autoCaps
    case icon
}

enum AppIconKey: String {
    
    case original
    case pro = "icon_pro"
    case dark = "icon_dark"
}
