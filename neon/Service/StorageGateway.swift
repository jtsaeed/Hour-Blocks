//
//  StorageGateway.swift
//  neon
//
//  Created by James Saeed on 16/05/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import Foundation

class StorageGateway {
	
	static let shared = StorageGateway()
	
	func saveEnabledCalendars(_ calendars: [String: Bool]) {
		UserDefaults.standard.set(calendars, forKey: "enabledCalendars")
	}
	
	func loadEnabledCalendars() -> [String: Bool]? {
		return UserDefaults.standard.dictionary(forKey: "enabledCalendars") as? [String: Bool]
	}
}
