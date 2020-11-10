//
//  Suggestion.swift
//  neon
//
//  Created by James Saeed on 12/02/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import Foundation

/// The model for an Suggestion to be used for a suggested Hour Block.
struct Suggestion: Identifiable {
    
    let id: String
    
    let domain: BlockDomain
    let reason: String
    let score: Int
    
    /// Creates an instance of a Suggestion.
    ///
    /// - Parameters:
    ///   - domain: The corresponding domain for the suggestion.
    ///   - reason: The reason why this suggestion was generated for the user.
    ///   - score: The value determining how highly the suggestion ranks.
    init(domain: BlockDomain, reason: String, score: Int) {
        self.id = UUID().uuidString
        self.domain = domain
        self.reason = reason
        self.score = score
    }
}
