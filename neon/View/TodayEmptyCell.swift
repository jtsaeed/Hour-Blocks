//
//  TodayEmptyCell.swift
//  neon
//
//  Created by James Saeed on 06/02/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import UIKit

protocol AddAgendaDelegate {
    func showAddAgendaDialog(forCardPosition cardPosition: Int)
}

class TodayEmptyCell: UITableViewCell {
    
    var delegate: AddAgendaDelegate!

    @IBOutlet weak var time: UILabel!
    var cardPosition: Int!
    
    func build(forHour hour: Int, atPosition position: Int) {
        self.time.text = hour.getFormattedHour()
        self.cardPosition = position
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        self.delegate.showAddAgendaDialog(forCardPosition: cardPosition)
    }
}
