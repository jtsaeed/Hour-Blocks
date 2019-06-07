//
//  TodayEmptyCell.swift
//  neon
//
//  Created by James Saeed on 06/02/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import UIKit

protocol AddAgendaDelegate {
	
    func showAddAgendaDialog(for block: Block?, at indexPath: IndexPath)
}

class EmptyBlockCell: UITableViewCell {
    
    var delegate: AddAgendaDelegate!

	@IBOutlet weak var time: UILabel!
	@IBOutlet weak var emptyLabel: UILabel!
	@IBOutlet weak var addButton: UIButtonX!
	
    var indexPath: IndexPath!
    
    func build(for hour: Int, at indexPath: IndexPath) {
        time.text = hour.getFormattedHour()
		emptyLabel.text = AppStrings.Schedule.empty
		addButton.setTitle(AppStrings.Schedule.add.uppercased(), for: .normal)
		
        self.indexPath = indexPath
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        delegate.showAddAgendaDialog(for: nil, at: indexPath)
    }
}
