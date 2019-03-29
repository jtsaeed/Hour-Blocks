//
//  TodayEmptyCell.swift
//  neon
//
//  Created by James Saeed on 06/02/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import UIKit

protocol AddAgendaDelegate {
    func showAddAgendaDialog(for agendaCard: AgendaCard?, at indexPath: IndexPath)
}

class EmptyCardCell: UITableViewCell {
    
    var delegate: AddAgendaDelegate!

    @IBOutlet weak var time: UILabel!
    var indexPath: IndexPath!
    
    func build(for hour: Int, at indexPath: IndexPath) {
        self.time.text = hour.getFormattedHour()
        self.indexPath = indexPath
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        self.delegate.showAddAgendaDialog(for: nil, at: indexPath)
    }
}
