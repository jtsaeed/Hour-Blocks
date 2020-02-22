//
//  BlockDomains.swift
//  neon3
//
//  Created by James Saeed on 08/07/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import Foundation
import NaturalLanguage

class DomainsGateway {
    
    static let shared = DomainsGateway()
    
    /// Determines the potential domain for a given Hour Block's title by evaluating the potential domain for each word within the title
    ///
    /// - Parameter title: The title of the given Hour Block
    func determineDomain(for title: String?) -> BlockDomain? {
        guard let words = title?.components(separatedBy: " ") else { return nil }
        
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
    
    /// Determines the potential domain for a given word by using similar word embeddings
    ///
    /// - Parameter word: The word to evaluate
    private func determineDomainRating(for word: String) -> (domain: BlockDomain, rating: Double)? {
        var determinedDomain: BlockDomain?
        var rating = 0.0
        
        let locale = Locale.current.languageCode
        print("LOCALE: \(locale)")
        let embedding = NLEmbedding.wordEmbedding(for: .english)
        
        for domain in BlockDomain.allCases {
            var localisedDomainName = domain.rawValue
            if locale == "de" { localisedDomainName = domain.german }
            
            print("DOMAINS: \(localisedDomainName)")
            
            // Check if the word directly matches the keyword of the domain in the loop
            if localisedDomainName == word {
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
            } else {
                print("LANGUAGE NOT SUPPORTED")
                AnalyticsGateway.shared.logMLFailed()
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
