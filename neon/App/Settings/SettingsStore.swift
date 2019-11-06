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
    
    init() {
        enabledCalendars = DataGateway.shared.loadEnabledCalendars()
    }
    
    func toggleCalendar(for identifier: String, to status: Bool) {
        print("Toggling \(identifier) to \(status)")
        
        enabledCalendars[identifier] = status
    }
}
