//
//  TodayViewController.swift
//  neonToday
//
//  Created by James Saeed on 26/03/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var label: UILabel!
	
	var blocks = [Int: [Block]]() {
		didSet {
			blocks[Day.today.rawValue] = blocks[Day.today.rawValue]?.filter { $0.hour >= Calendar.current.component(.hour, from: Date()) }
		}
	}
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.blocks = DataGateway.shared.loadBlocks()
		setLabel(for: blocks[Day.today.rawValue]?.first?.agendaItem)
    }
    
    func setLabel(for agendaItem: AgendaItem?) {
        DispatchQueue.main.async {
            if let title = agendaItem?.title {
                self.label.text = title.capitalized
            } else {
                self.label.text = AppStrings.Extensions.Today.nothingScheduled
            }
        }
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
