//
//  DomainsGateway.swift
//  neon3
//
//  Created by James Saeed on 08/07/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import Foundation
import NaturalLanguage

/// A singleton gateway service used to interface with the Hour Blocks domains framework.
class DomainsGateway {
    
    static let shared = DomainsGateway()
    
    /// Determines the domain for a given title.
    ///
    /// - Parameters:
    ///   - title: The title to match a domain to.
    ///
    /// - Returns:
    /// A domain if one was determined.
    func determineDomain(for title: String?) -> BlockDomain? {
        guard let words = title?.components(separatedBy: " ") else { return nil }
        
        // Determine the domain for each individual word, then choose the highest rated domain across the string
        var topDomain: BlockDomain?
        var topRating = 0.0
        for word in words {
            if let domainRating = determineDomainRating(for: word.lowercased()) {
                if domainRating.rating > topRating {
                    topDomain = domainRating.domain
                    topRating = domainRating.rating
                }
            }
        }
        
        return topDomain
    }
    
    /// Determines the domain for a given title.
    ///
    /// - Parameters:
    ///   - word: The word to match a domain to.
    ///
    /// - Returns:
    /// A tuple containing the determined domain and the rating of the match; only returned if a domain is matched.
    private func determineDomainRating(for word: String) -> (domain: BlockDomain, rating: Double)? {
        var determinedDomain: BlockDomain?
        var rating = 0.0
        
        let embedding = NLEmbedding.wordEmbedding(for: .english)
        
        for domain in BlockDomain.allCases {
            // Check if the word directly matches the keyword of the domain in the loop
            if domain.rawValue == word {
                determinedDomain = domain
                rating = 1
                break
            }
            
            if embedding != nil {
                embedding!.enumerateNeighbors(for: domain.rawValue, maximumCount: 25) { string, distance in
                    // If a similar word was found, return the corresponding domain and the match rating
                    if string == word {
                        let tempRating = (1 - distance.magnitude).magnitude
                        
                        if tempRating > rating {
                            rating = tempRating
                            determinedDomain = domain
                        }
                    }
                    
                    return true
                }
            }
        }
        
        // If a domain was found, return it with the rating, otherwise return nil
        if let domain = determinedDomain {
            return (domain: domain, rating: rating)
        } else {
            return nil
        }
    }
}
