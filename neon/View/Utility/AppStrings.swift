//
//  AppStrings.swift
//  neon
//
//  Created by James Saeed on 26/05/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import Foundation

struct AppStrings {
	
	static let cancel = "Cancel"
	
	struct Schedule {
		
		// Title on the tab bar
		static let tab = NSLocalizedString("tabSchedule", comment: "")
		
		// Section headers
		static let todayHeader = NSLocalizedString("todayHeader", comment: "")
		static let tomorrowHeader = NSLocalizedString("tomorrowHeader", comment: "")
		
		// The empty hour block
		static let empty = NSLocalizedString("empty", comment: "")
		static let add = NSLocalizedString("add", comment: "")
		
		// Action sheet options
		static let edit = NSLocalizedString("edit", comment: "")
		static let clear = NSLocalizedString("clear", comment: "")
		static let setReminder = NSLocalizedString("setReminder", comment: "")
		static let removeReminder = NSLocalizedString("removeReminder", comment: "")
		static let timeBeforeReminder = NSLocalizedString("timeBeforeReminder", comment: "")
		
		// Add agenda window
		static let addAgendaTitle = NSLocalizedString("addAgendaTitle", comment: "")
		static let done = NSLocalizedString("done", comment: "")
	}
	
	struct Settings {
		
		// Title on the tab bar
		static let tab = NSLocalizedString("tabSettings", comment: "")
		
		// Header
		static let header = NSLocalizedString("settingsHeader", comment: "")
		static let subHeader = NSLocalizedString("settingsSubHeader", comment: "")
		
		// Table view headers
		static let calendars = NSLocalizedString("calendars", comment: "")
		static let feedback = NSLocalizedString("feedback", comment: "")
		static let feedbackPlaceholder = NSLocalizedString("feedbackPlaceholder", comment: "")
		static let feedbackSubmit = NSLocalizedString("feedbackSubmit", comment: "")
		static let thankYou = NSLocalizedString("thankYou", comment: "")
		static let twitter = NSLocalizedString("twitter", comment: "")
	}
	
	struct Extensions {
		
		struct Today {
			
			static let nothingScheduled = NSLocalizedString("nothingScheduled", comment: "")
		}
	}
}
