//
//  Suggestion.swift
//  neon
//
//  Created by James Saeed on 12/02/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import Foundation

struct Suggestion: Hashable {
    
    var domain: BlockDomain
    var reason: String
    
    var title: String {
        guard let locale = Locale.current.languageCode else { return domain.suggestionTitle }
        
        return locale.starts(with: "en") ? domain.suggestionTitle : domain.localisedKey.capitalized
    }
}
