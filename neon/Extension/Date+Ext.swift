//
//  Date+Ext.swift
//  neon
//
//  Created by James Saeed on 07/02/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import Foundation

extension Date {
    
    func getFormattedDate() -> String {
        if Calendar.current.isDateInTomorrow(self) {
            return "Tomorrow"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E d MMM"
        
        return dateFormatter.string(from: self).uppercased()
    }
}
