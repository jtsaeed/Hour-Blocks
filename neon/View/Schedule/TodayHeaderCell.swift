//
//  TodayHeaderCell.swift
//  neon
//
//  Created by James Saeed on 07/02/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import UIKit

class TodayHeaderCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    
    func build() {
        self.dateLabel.text = Date().getFormattedDate()
    }
}
