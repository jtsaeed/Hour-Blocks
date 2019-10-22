//
//  Int+Ext.swift
//  neon3
//
//  Created by James Saeed on 01/10/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import Foundation

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
    
    func getFormattedMinute() -> String {
        if self == 1 {
            return ":15"
        } else if self == 2 {
            return ":30"
        } else if self == 3 {
            return ":45"
        } else {
            return ""
        }
    }
}
