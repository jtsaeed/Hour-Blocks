//
//  TodayCell.swift
//  neon
//
//  Created by James Saeed on 06/02/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import UIKit

class HourBlockCell: UITableViewCell {

    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    func build(with agendaItem: AgendaItem, for hour: Int) {
        time.text = hour.getFormattedHour()
        title.text = agendaItem.title.agendaCapitalisation()
        icon.image = UIImage(named: agendaItem.icon)?.withRenderingMode(.alwaysTemplate)
    }

}
