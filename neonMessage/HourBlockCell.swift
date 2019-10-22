//
//  HourBlockCell.swift
//  neonMessage
//
//  Created by James Saeed on 19/05/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import UIKit

class HourBlockCell: UITableViewCell {
	
	@IBOutlet weak var time: UILabel!
	@IBOutlet weak var title: UILabel!
	@IBOutlet weak var icon: UIImageView!
	
	func build(with possibleAgendaItem: AgendaItem?, for hour: Int) {
		time.text = hour.getFormattedHour()
		
		if let agendaItem = possibleAgendaItem {
			title.text = agendaItem.title.capitalized
            title.textColor = UIColor(named: "title")!
			icon.isHidden = false
			icon.image = UIImage(named: agendaItem.icon)?.withRenderingMode(.alwaysTemplate)
		} else {
			title.text = "Empty"
			title.textColor = UIColor(named: "subtitle")!
			icon.isHidden = true
		}
	}
	
}
