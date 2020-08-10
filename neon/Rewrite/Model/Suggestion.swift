//
//  Suggestion.swift
//  neon
//
//  Created by James Saeed on 12/02/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import Foundation

struct Suggestion: Identifiable {
    
    let id = UUID().uuidString
    var domain: BlockDomain
    var reason: String
    let score: Int
    
    var title: String {
        return domain.suggestionTitle
    }
}
