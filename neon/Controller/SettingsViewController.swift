//
//  SettingsViewController.swift
//  neon
//
//  Created by James Saeed on 16/05/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import UIKit
import EventKit

class SettingsViewController: UIViewController, Storyboarded {
	
	weak var coordinator: SettingsCoordinator?
	
	@IBOutlet weak var tableView: UITableView!
	
	var calendars = [EKCalendar]()
	var enabledCalendars: [String: Bool]?

    override func viewDidLoad() {
        super.viewDidLoad()
		
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = UITableView.automaticDimension
		tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 32, right: 0)
		
		calendars = CalendarGateway.shared.getAllCalendars().sorted(by: { $0.title < $1.title })
		enabledCalendars = StorageGateway.shared.loadEnabledCalendars()
    }
	
	@IBAction func swipedRight(_ sender: Any) {
		coordinator?.swipeToSchedule()
	}
}

// MARK: - Table View

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 48
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let sectionHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 48))
		sectionHeaderView.backgroundColor = .white
		
		let sectionHeader = UILabel(frame: CGRect(x: 32, y: 0, width: tableView.bounds.width - 32, height: 48))
		sectionHeader.font = UIFont.boldSystemFont(ofSize: 24)
		
		if section == SettingsSection.calendar.rawValue {
			sectionHeader.text = "Calendars"
		} else if section == SettingsSection.feedback.rawValue {
			sectionHeader.text = "Feedback"
		}
		
		sectionHeaderView.addSubview(sectionHeader)
		return sectionHeaderView
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == SettingsSection.calendar.rawValue {
			return calendars.count
		} else if section == SettingsSection.feedback.rawValue {
			return 1
		} else {
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.section == SettingsSection.calendar.rawValue {
			return 38
		} else if indexPath.section == SettingsSection.feedback.rawValue {
			return 240
		} else {
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.section == SettingsSection.calendar.rawValue {
			return buildCalendarSettingCell(at: indexPath)
		} else if indexPath.section == SettingsSection.feedback.rawValue {
			return buildFeedbackSettingCell(at: indexPath)
		} else {
			return UITableViewCell()
		}
	}
	
	func buildCalendarSettingCell(at indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "calendarSettingCell") as? CalendarSettingCell else { return UITableViewCell() }
		
		let calendar = calendars[indexPath.row]
		cell.build(for: calendar, status: enabledCalendars?[calendar.calendarIdentifier] ?? true)
		cell.delegate = self
		
		return cell
	}
	
	func buildFeedbackSettingCell(at indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "feedbackSettingCell") as? FeedbackSettingCell else { return UITableViewCell() }
		cell.build()
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
	
	case calendar = 0, feedback = 1
}
