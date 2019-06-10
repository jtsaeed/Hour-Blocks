//
//  ToDoBlockCell.swift
//  neon
//
//  Created by James Saeed on 13/05/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import UIKit

class ToDoBlockCell: UICollectionViewCell {
	
	@IBOutlet weak var priorityLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	
	func build(with toDoItem: ToDoItem) {
		priorityLabel.text = toDoItem.priority.rawValue
		titleLabel.text = toDoItem.title
		
		switch toDoItem.priority {
			case .none: priorityLabel.textColor = UIColor(named: "gray")
			case .high: priorityLabel.textColor = UIColor(named: "highPriority")
			case .medium: priorityLabel.textColor = UIColor(named: "medPriority")
			case .low: priorityLabel.textColor = UIColor(named: "lowPriority")
		}
	}

}
