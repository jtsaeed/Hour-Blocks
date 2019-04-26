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
    
    func build(for type: SectionType) {
        if type == .today {
            dateLabel.text = Date().getFormattedDate()
			eventLabel.text = CalendarGateway.shared.todaysAllDayEvent?.title.uppercased() ?? ""
            titleLabel.text = "Today"
        } else if type == .tomorrow {
            dateLabel.text = Calendar.current.date(byAdding: .day, value: 1, to: Date())!.getFormattedDate()
			eventLabel.text = CalendarGateway.shared.tomorrowsAllDayEvent?.title.uppercased() ?? ""
            titleLabel.text = "Tomorrow"
        }
    }
}

enum SectionType: Int {
    case today = 0, tomorrow = 1
}
