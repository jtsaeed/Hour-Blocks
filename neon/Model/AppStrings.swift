//
//  AppStrings.swift
//  neon
//
//  Created by James Saeed on 26/05/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import Foundation

struct AppStrings {
	
	static let cancel = NSLocalizedString("cancel", comment: "")
	
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
		static let other = NSLocalizedString("other", comment: "")
		static let feedback = NSLocalizedString("feedback", comment: "")
		static let about = NSLocalizedString("about", comment: "")
		
		// Items
		static let feedbackPlaceholder = NSLocalizedString("feedbackPlaceholder", comment: "")
		static let feedbackSubmit = NSLocalizedString("feedbackSubmit", comment: "")
		static let thankYou = NSLocalizedString("thankYou", comment: "")
		static let twitter = NSLocalizedString("twitter", comment: "")
	}
	
	struct Icons {
		
		static let bank = [NSLocalizedString("bank1", comment: ""), NSLocalizedString("bank2", comment: "")]
		static let brush = [NSLocalizedString("brush1", comment: ""), NSLocalizedString("brush2", comment: ""), NSLocalizedString("brush3", comment: ""), NSLocalizedString("brush4", comment: "")]
		static let code = [NSLocalizedString("code1", comment: ""), NSLocalizedString("code2", comment: ""), NSLocalizedString("code3", comment: ""), NSLocalizedString("code4", comment: "")]
		static let commute = [NSLocalizedString("commute1", comment: ""), NSLocalizedString("commute2", comment: ""), NSLocalizedString("commute3", comment: "")]
		static let couch = [NSLocalizedString("couch1", comment: ""), NSLocalizedString("couch2", comment: "")]
		static let education = [NSLocalizedString("education1", comment: ""), NSLocalizedString("education2", comment: ""), NSLocalizedString("education3", comment: ""), NSLocalizedString("education4", comment: ""), NSLocalizedString("education5", comment: ""), NSLocalizedString("education6", comment: ""), NSLocalizedString("education7", comment: "")]
		static let food = [NSLocalizedString("food1", comment: ""), NSLocalizedString("food2", comment: ""), NSLocalizedString("food3", comment: ""), NSLocalizedString("food4", comment: ""), NSLocalizedString("food5", comment: ""), NSLocalizedString("food6", comment: ""), NSLocalizedString("food7", comment: ""), NSLocalizedString("food8", comment: "")]
		static let game = [NSLocalizedString("game1", comment: ""), NSLocalizedString("game2", comment: ""), NSLocalizedString("game3", comment: "")]
		static let gym = [NSLocalizedString("gym1", comment: ""), NSLocalizedString("gym2", comment: ""), NSLocalizedString("gym3", comment: ""), NSLocalizedString("gym4", comment: "")]
		static let health = [NSLocalizedString("health1", comment: ""), NSLocalizedString("health2", comment: ""), NSLocalizedString("health3", comment: "")]
		static let house = [NSLocalizedString("house1", comment: ""), NSLocalizedString("house2", comment: ""), NSLocalizedString("house3", comment: "")]
		static let love = [NSLocalizedString("love1", comment: ""), NSLocalizedString("love2", comment: ""), NSLocalizedString("love3", comment: "")]
		static let movie = [NSLocalizedString("movie1", comment: ""), NSLocalizedString("movie2", comment: ""), NSLocalizedString("movie3", comment: "")]
		static let music = [NSLocalizedString("music1", comment: ""), NSLocalizedString("music2", comment: ""), NSLocalizedString("music3", comment: ""), NSLocalizedString("music4", comment: "")]
		static let pencil = [NSLocalizedString("pencil1", comment: "")]
		static let people = [NSLocalizedString("people1", comment: ""), NSLocalizedString("people2", comment: ""), NSLocalizedString("people3", comment: "")]
		static let sleep = [NSLocalizedString("sleep1", comment: ""), NSLocalizedString("sleep2", comment: ""), NSLocalizedString("sleep3", comment: ""), NSLocalizedString("sleep4", comment: "")]
		static let store = [NSLocalizedString("store1", comment: ""), NSLocalizedString("store2", comment: ""), NSLocalizedString("store3", comment: "")]
		static let sun = [NSLocalizedString("sun1", comment: ""), NSLocalizedString("sun2", comment: ""), NSLocalizedString("sun3", comment: ""), NSLocalizedString("sun4", comment: ""), NSLocalizedString("sun5", comment: "")]
		static let work = [NSLocalizedString("work1", comment: ""), NSLocalizedString("work2", comment: ""), NSLocalizedString("work3", comment: ""), NSLocalizedString("work4", comment: "")]
	}
	
	struct Extensions {
		
		struct Today {
			
			static let nothingScheduled = NSLocalizedString("nothingScheduled", comment: "")
		}
	}
}
