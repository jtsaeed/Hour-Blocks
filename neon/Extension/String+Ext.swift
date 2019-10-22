//
//  String+Ext.swift
//  neon
//
//  Created by James Saeed on 06/08/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import Foundation

extension String {
    
    func neonCapitalisation() -> String {
        let tempTitle = self.split(separator: " ")
        var finalTitle = ""
        
        for word in tempTitle {
            if word == "to" || word == "and" || word == "with" || word == "for" || word == "a" || word == "at" || word == "in" {
                finalTitle += (word + " ")
            } else {
                finalTitle += (word.capitalized + " ")
            }
        }
        
        finalTitle.removeLast()
        
        return finalTitle
    }
}
