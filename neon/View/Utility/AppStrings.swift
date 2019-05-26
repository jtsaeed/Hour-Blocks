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
		static let tab = "Schedule"
		
		// Section headers
		static let todayHeader = "Today"
		static let tomorrowHeader = "Tomorrow"
		
		// The empty hour block
		static let empty = "Empty"
		static let add = "ADD"
		
		// Action sheet options
		static let edit = "Edit"
		static let clear = "Clear"
		static let setReminder = "Set Reminder"
		static let removeReminder = "Remove Reminder"
		static let timeBeforeReminder = "%@ minutes before"
		
		// Add agenda window
		static let addAgendaTitle = "What's in store at %@?"
		static let done = "Done"
	}
	
	struct Settings {
		
		// Title on the tab bar
		static let tab = "Settings"
		
		// Header
		static let header = "Settings"
		static let subHeader = "TAKE CONTROL"
		
		// Table view headers
		static let calendars = "Calendars"
		static let feedback = "Feedback"
		static let feedbackPlaceholder = "If you have any thoughts about your Hour Blocks experience, let me know here!"
		static let feedbackSubmit = "Submit feedback"
		static let twitter = "Follow me on Twitter for updates"
	}
	
	struct Extensions {
		
		struct Today {
			
			static let nothingScheduled = "Nothing scheduled"
		}
	}
}
