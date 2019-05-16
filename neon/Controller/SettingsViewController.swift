//
//  SettingsViewController.swift
//  neon
//
//  Created by James Saeed on 16/05/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import UIKit
import EventKit

class SettingsViewController: UIViewController {
	
	var calendars = [EKCalendar]()
	var enabledCalendars: [String: Bool]?

    override func viewDidLoad() {
        super.viewDidLoad()
		
		calendars = CalendarGateway.shared.getAllCalendars()
		enabledCalendars = StorageGateway.shared.loadEnabledCalendars()
    }
	
	@IBAction func swipedRight(_ sender: Any) {
		tabBarController?.selectedIndex = 0
	}
}

// MARK: - Table View

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 32
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let sectionHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 32))
		sectionHeaderView.backgroundColor = .white
		
		let sectionHeader = UILabel(frame: CGRect(x: 32, y: 0, width: tableView.bounds.width - 32, height: 32))
		sectionHeader.text = "Calendars"
		sectionHeader.font = UIFont.boldSystemFont(ofSize: 24)
		
		sectionHeaderView.addSubview(sectionHeader)
		return sectionHeaderView
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return calendars.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "calendarSettingCell") as? CalendarSettingCell else { return UITableViewCell() }
		
		let calendar = calendars[indexPath.row]
		cell.build(for: calendar, status: enabledCalendars?[calendar.calendarIdentifier] ?? true)
		cell.delegate = self
		
		return cell
	}
}

// MARK: - Settings Delegates

extension SettingsViewController: CalendarSettingDelegate {
	
	func toggleCalendar(for identifier: String, to status: Bool) {
		if enabledCalendars == nil {
			initialiseEnabledCalendars()
		}
		
		enabledCalendars?[identifier] = status
		
		StorageGateway.shared.saveEnabledCalendars(enabledCalendars!)
	}
	
	private func initialiseEnabledCalendars() {
		enabledCalendars = [String: Bool]()
			
		for calendar in calendars {
			enabledCalendars?[calendar.calendarIdentifier] = true
		}
	}
}

enum SettingsSection: Int {
	
	case calendar = 0, notifications = 1, feedback = 2
}
