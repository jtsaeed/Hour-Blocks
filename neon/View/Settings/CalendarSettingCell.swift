//
//  CalendarSettingCell.swift
//  neon
//
//  Created by James Saeed on 16/05/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import UIKit
import EventKit

protocol CalendarSettingDelegate {
	
	func toggleCalendar(for identifier: String, to status: Bool)
}

class CalendarSettingCell: UITableViewCell {

	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var toggleSwitch: UISwitch!
	
	var delegate: CalendarSettingDelegate!
	var calendarIdentifier: String!
	
	func build(for calendar: EKCalendar, status: Bool) {
		nameLabel.text = calendar.title
		calendarIdentifier = calendar.calendarIdentifier
		toggleSwitch.isOn = status
	}
	
	@IBAction func switchPressed(_ sender: Any) {
		delegate.toggleCalendar(for: calendarIdentifier, to: toggleSwitch.isOn)
	}
	
}
