//
//  SectionHeaderView.swift
//  neon
//
//  Created by James Saeed on 25/02/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import UIKit

class SectionHeaderView: UIView {

    @IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var eventLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
    
    func build(for type: Day?) {
        if type == .today {
            dateLabel.text = Date().getFormattedDate()
			eventLabel.text = CalendarGateway.shared.todaysAllDayEvent?.title.uppercased() ?? ""
            titleLabel.text = AppStrings.Schedule.todayHeader
        } else if type == .tomorrow {
            dateLabel.text = Calendar.current.date(byAdding: .day, value: 1, to: Date())!.getFormattedDate()
			eventLabel.text = CalendarGateway.shared.tomorrowsAllDayEvent?.title.uppercased() ?? ""
            titleLabel.text = AppStrings.Schedule.tomorrowHeader
		} else {
			dateLabel.text = "9 ITEMS"
			eventLabel.text = ""
			titleLabel.text = "To Do List"
		}
    }
}
