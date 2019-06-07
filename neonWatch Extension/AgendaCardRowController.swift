//
//  AgendaCardRowController.swift
//  neonWatch Extension
//
//  Created by James Saeed on 27/03/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import Foundation
import WatchKit

class AgendaCardRowController: NSObject {
    
    var agendaCard: AgendaCard? {
        didSet {
            timeLabel.setText(agendaCard?.hour.getFormattedHour() ?? "")
            titleLabel.setText(agendaCard?.agendaItem?.title.capitalized ?? "Empty")
        }
    }
    
    @IBOutlet weak var timeLabel: WKInterfaceLabel!
    @IBOutlet weak var titleLabel: WKInterfaceLabel!
}

extension Int {
    
    func getFormattedHour() -> String {
        if self == 0 {
            return "12AM"
        } else if self < 12 {
            return "\(self)AM"
        } else if self == 12 {
            return "\(self)PM"
        } else {
            return "\(self - 12)PM"
        }
    }
}
