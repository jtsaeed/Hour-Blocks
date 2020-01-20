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
    
    var domains = [String: BlockDomain]()
    
    init() {
        domains["calendar"] = BlockDomain(key: "calendar", iconName: "calendar_item", suggestionTitle: "")
        
        domains["wake"] = BlockDomain(key: "wake", iconName: "alarm_clock", suggestionTitle: "wake up")
        
        domains["read"] = BlockDomain(key: "read", iconName: "chrome_reader", suggestionTitle: "read")
        domains["book"] = BlockDomain(key: "book", iconName: "chrome_reader", suggestionTitle: "read book")
        domains["quran"] = BlockDomain(key: "quran", iconName: "chrome_reader", suggestionTitle: "read quran")
        
        domains["code"] = BlockDomain(key: "code", iconName: "code", suggestionTitle: "programming")
        
        domains["commute"] = BlockDomain(key: "commute", iconName: "commute", suggestionTitle: "commute")
        
        domains["home"] = BlockDomain(key: "home", iconName: "home", suggestionTitle: "go home")
        
        domains["shopping"] = BlockDomain(key: "shopping", iconName: "shopping_cart", suggestionTitle: "shopping")
        
        domains["store"] = BlockDomain(key: "store", iconName: "store", suggestionTitle: "go to the store")
        
        domains["movie"] = BlockDomain(key: "movie", iconName: "theaters", suggestionTitle: "watch a movie")
        
        domains["work"] = BlockDomain(key: "work", iconName: "work", suggestionTitle: "work")
        
        domains["call"] = BlockDomain(key: "call", iconName: "call", suggestionTitle: "phone call")
        
        domains["email"] = BlockDomain(key: "email", iconName: "email", suggestionTitle: "emails")
        
        domains["vote"] = BlockDomain(key: "vote", iconName: "how_to_vote", suggestionTitle: "vote")
        
        domains["write"] = BlockDomain(key: "write", iconName: "create", suggestionTitle: "write")
        domains["draw"] = BlockDomain(key: "draw", iconName: "create", suggestionTitle: "draw")
        
        domains["shower"] = BlockDomain(key: "shower", iconName: "waves", suggestionTitle: "have a shower")
        
        domains["swim"] = BlockDomain(key: "swim", iconName: "pool", suggestionTitle: "swimming")
        
        domains["tv"] = BlockDomain(key: "tv", iconName: "tv", suggestionTitle: "watch tv")
        
        domains["music"] = BlockDomain(key: "music", iconName: "music_note", suggestionTitle: "music")
        domains["guitar"] = BlockDomain(key: "guitar", iconName: "music_note", suggestionTitle: "guitar")
        domains["piano"] = BlockDomain(key: "piano", iconName: "music_note", suggestionTitle: "piano")
        
        domains["paint"] = BlockDomain(key: "paint", iconName: "brush", suggestionTitle: "paint")
        
        domains["design"] = BlockDomain(key: "design", iconName: "palette", suggestionTitle: "design")
        
        domains["walk"] = BlockDomain(key: "walk", iconName: "nature_people", suggestionTitle: "go for a walk")
        
        domains["morning"] = BlockDomain(key: "morning", iconName: "wb_sunny", suggestionTitle: "morning routine")
        
        domains["drive"] = BlockDomain(key: "drive", iconName: "directions_car", suggestionTitle: "drive")
        
        domains["run"] = BlockDomain(key: "run", iconName: "directions_run", suggestionTitle: "go for a run")
        
        domains["bus"] = BlockDomain(key: "bus", iconName: "directions_bus", suggestionTitle: "get the bus")
        
        domains["train"] = BlockDomain(key: "train", iconName: "directions_subway", suggestionTitle: "get the train")
        
        domains["flight"] = BlockDomain(key: "flight", iconName: "flight", suggestionTitle: "flight")
        
        domains["sleep"] = BlockDomain(key: "sleep", iconName: "hotel", suggestionTitle: "sleep")
        domains["nap"] = BlockDomain(key: "nap", iconName: "hotel", suggestionTitle: "have a nap")
        
        domains["party"] = BlockDomain(key: "party", iconName: "local_bar", suggestionTitle: "party")
        
        domains["coffee"] = BlockDomain(key: "coffee", iconName: "local_cafe", suggestionTitle: "have a coffee")
        
        domains["laundry"] = BlockDomain(key: "laundry", iconName: "local_laundry", suggestionTitle: "do laundry")
        
        domains["meditate"] = BlockDomain(key: "meditate", iconName: "local_florist", suggestionTitle: "meditate")
        domains["yoga"] = BlockDomain(key: "yoga", iconName: "local_florist", suggestionTitle: "yoga")
        
        domains["eat"] = BlockDomain(key: "eat", iconName: "restaurant", suggestionTitle: "eat food")
        domains["cook"] = BlockDomain(key: "cook", iconName: "restaurant", suggestionTitle: "cook food")
        domains["breakfast"] = BlockDomain(key: "breakfast", iconName: "restaurant", suggestionTitle: "have breakfast")
        domains["lunch"] = BlockDomain(key: "lunch", iconName: "restaurant", suggestionTitle: "have lunch")
        domains["dinner"] = BlockDomain(key: "dinner", iconName: "restaurant", suggestionTitle: "have dinner")
        
        domains["exercise"] = BlockDomain(key: "exercise", iconName: "fitness_center", suggestionTitle: "exercise")
        domains["gym"] = BlockDomain(key: "gym", iconName: "fitness_center", suggestionTitle: "go to the gym")
        
        domains["golf"] = BlockDomain(key: "golf", iconName: "golf_course", suggestionTitle: "golf")
        
        domains["competition"] = BlockDomain(key: "competition", iconName: "emoji_events", suggestionTitle: "competition")
        
        domains["meeting"] = BlockDomain(key: "meeting", iconName: "group", suggestionTitle: "meeting")
        
        domains["school"] = BlockDomain(key: "school", iconName: "school", suggestionTitle: "school")
        domains["lecture"] = BlockDomain(key: "lecture", iconName: "school", suggestionTitle: "class")
        domains["study"] = BlockDomain(key: "study", iconName: "school", suggestionTitle: "study")
        domains["homework"] = BlockDomain(key: "homework", iconName: "school", suggestionTitle: "homework")
        domains["exam"] = BlockDomain(key: "exam", iconName: "school", suggestionTitle: "exam")
        
        domains["baseball"] = BlockDomain(key: "basbell", iconName: "sports_baseball", suggestionTitle: "baseball")
        domains["basketball"] = BlockDomain(key: "basketball", iconName: "sports_basketball", suggestionTitle: "basketball")
        domains["cricket"] = BlockDomain(key: "cricket", iconName: "sports_cricket", suggestionTitle: "cricket")
        domains["hockey"] = BlockDomain(key: "hockey", iconName: "sports_hockey", suggestionTitle: "hockey")
        domains["rugby"] = BlockDomain(key: "rugby", iconName: "sports_rugby", suggestionTitle: "rugby")
        domains["football"] = BlockDomain(key: "football", iconName: "sports_soccer", suggestionTitle: "football")
        domains["tennis"] = BlockDomain(key: "tennis", iconName: "sports_tennis", suggestionTitle: "tennis")
        domains["volleyball"] = BlockDomain(key: "volleyball", iconName: "sports_volleyball", suggestionTitle: "volleyball")
    }
    
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
        
        guard let embedding = NLEmbedding.wordEmbedding(for: .english) else { return nil }
        
        for domain in domains {
            // Check if the word directly matches the keyword of the domain in the loop
            if domain.key == word {
                determinedDomain = domain.value
                rating = 1
                break
            }
            
            embedding.enumerateNeighbors(for: domain.key, maximumCount: 25) { (string, distance) -> Bool in
                // If a similar word was found, return the corresponding domain and the match rating
                if string == word {
                    let tempRating = (1 - distance.magnitude).magnitude
                    
                    if tempRating > rating {
                        rating = tempRating
                        determinedDomain = domain.value
                    }
                }
                
                return true
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

struct BlockDomain: Hashable {
    
    let key: String
    let iconName: String
    let suggestionTitle: String
}
