//
//  VersionGateway.swift
//  Hour Blocks
//
//  Created by James Saeed on 27/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import Foundation

struct VersionGateway {
    
    static let shared = VersionGateway()
    
    let currentVersion = 6.0
    let fullCurrentVersion = "6.0 Beta 4"
    
    func isNewVersion() -> Bool {
        guard let userVersion = UserDefaults.standard.object(forKey: "currentVersion") as? Double else {
            UserDefaults.standard.set(currentVersion, forKey: "currentVersion")
            return false
        }
        
        UserDefaults.standard.set(currentVersion, forKey: "currentVersion")
        UserDefaults.standard.synchronize()
        
        return userVersion < currentVersion
    }
}
