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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataGateway.shared.fetchAgendaItems { (todaysAgendaItems, tomorrowsAgendaItems) in
            self.setLabel(for: todaysAgendaItems[Calendar.current.component(.hour, from: Date())])
        }
    }
    
    func setLabel(for agendaItem: AgendaItem?) {
        DispatchQueue.main.async {
            if let title = agendaItem?.title {
                self.label.text = title.capitalized
            } else {
                self.label.text = "Nothing scheduled"
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
