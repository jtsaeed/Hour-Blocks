//
//  String+Ext.swift
//  neon
//
//  Created by James Saeed on 30/10/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import Foundation

extension String {
    
    func smartCapitalization() -> String {
        if let setting = DataGateway.shared.loadOtherSettings()[OtherSettingsKey.autoCaps.rawValue] {
            if setting == 1 { return self }
        }
        
        var title = ""
        let words = self.lowercased().components(separatedBy: " ")
        
        for word in words {
            if word == "to" || word == "and" || word == "with" || word == "for" || word == "a" || word == "at" || word == "in" || word.hasPrefix("1") || word.hasPrefix("2") || word.hasPrefix("3") || word.hasPrefix("4") || word.hasPrefix("5") || word.hasPrefix("6") || word.hasPrefix("7") || word.hasPrefix("8") || word.hasPrefix("9") || word.hasPrefix("0") {
                title += (word + " ")
            } else {
                title += (word.capitalized + " ")
            }
        }
        
        return title
    }
}
