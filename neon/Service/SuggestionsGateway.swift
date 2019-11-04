//
//  Suggestions.swift
//  neon3
//
//  Created by James Saeed on 30/09/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import Foundation

struct SuggestionsGateway {
    
    static let shared = SuggestionsGateway()
    
    func getSuggestions(for hour: Int) -> [Suggestion] {
        var suggestions = [Suggestion]()
        
        suggestions.append(Suggestion(title: "Have dinner", reason: "popular"))
        
        return suggestions
    }
}

struct Suggestion {
    
    var title: String
    var reason: String
}
