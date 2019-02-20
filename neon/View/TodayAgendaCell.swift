//
//  TodayCell.swift
//  neon
//
//  Created by James Saeed on 06/02/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import UIKit

class TodayAgendaCell: UITableViewCell {

    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    func build(with agendaItem: AgendaItem, forHour hour: Int) {
        self.time.text = hour.getFormattedHour()
        self.title.text = agendaItem.title.capitalized
        self.icon.image = UIImage(named: agendaItem.icon)?.withRenderingMode(.alwaysTemplate)
    }

}
