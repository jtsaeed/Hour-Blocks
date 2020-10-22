//
//  VersionGateway.swift
//  Hour Blocks
//
//  Created by James Saeed on 27/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import Foundation

/// A singleton gateway service used to interface with app version related activity.
struct VersionGateway {
    
    static let shared = VersionGateway()
    
    let currentMajorVersion = 6.1
    let currentFullVersion = "6.1"
    
    /// Determines whether or not the user has launched a new major app update for the first time; called in order to trigger the presentation of the WhatsNewView.
    ///
    /// - Returns:
    /// Whether a new major version has been launched for the first time or not.
    func isNewVersion() -> Bool {
        // Check if the user has had a previous version of the app installed
        guard let userVersion = UserDefaults.standard.object(forKey: "currentVersion") as? Double else {
            UserDefaults.standard.set(currentMajorVersion, forKey: "currentVersion")
            return false
        }
        
        UserDefaults.standard.set(currentMajorVersion, forKey: "currentVersion")
        UserDefaults.standard.synchronize()
        
        return userVersion < currentMajorVersion
    }
}
