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
	
	func loadEnabledCalendars() -> [String]? {
		var calendarList = [String]()
		
		if let enabledCalendars = UserDefaults.standard.dictionary(forKey: "enabledCalendars") as? [String: Bool] {
			for calendar in enabledCalendars {
				if calendar.value == true { calendarList.append(calendar.key) }
			}
			
			return calendarList
		} else {
			return nil
		}
	}
}
