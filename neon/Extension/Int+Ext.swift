//
//  Int+Ext.swift
//  neon
//
//  Created by James Saeed on 11/11/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import Foundation

extension Int {
    
    /// Converts an hour value to a formatted 12h string.
    ///
    /// - Returns:
    /// A formatted 12h string.
    func get12hTime() -> String {
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
    
    /// Converts an hour value to a formatted 24h string.
    ///
    /// - Returns:
    /// A formatted 24h string.
    func get24hTime() -> String {
        if self >= 10 {
            return "\(self):00"
        } else {
            return "0\(self):00"
        }
    }
}
