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
    
    let wake = BlockDomain(keyWord: "wake", iconName: "alarm", suggestionTitle: "wake up")
    
    let read = BlockDomain(keyWord: "read", iconName: "chrome_reader", suggestionTitle: "read")
    let book = BlockDomain(keyWord: "book", iconName: "chrome_reader", suggestionTitle: "read book")
    let quran = BlockDomain(keyWord: "quran", iconName: "chrome_reader", suggestionTitle: "read quran")
    
    let code = BlockDomain(keyWord: "code", iconName: "code", suggestionTitle: "programming")
    
    let commute = BlockDomain(keyWord: "commute", iconName: "commute", suggestionTitle: "commute")
    
    let home = BlockDomain(keyWord: "home", iconName: "home", suggestionTitle: "go home")
    
    let shopping = BlockDomain(keyWord: "shopping", iconName: "shopping_cart", suggestionTitle: "shopping")
    
    let store = BlockDomain(keyWord: "store", iconName: "store", suggestionTitle: "go to the store")
    
    let movie = BlockDomain(keyWord: "movie", iconName: "theaters", suggestionTitle: "watch a movie")
    
    let work = BlockDomain(keyWord: "work", iconName: "work", suggestionTitle: "work")
    
    let call = BlockDomain(keyWord: "call", iconName: "call", suggestionTitle: "phone call")
    
    let email = BlockDomain(keyWord: "email", iconName: "email", suggestionTitle: "emails")
    
    let vote = BlockDomain(keyWord: "vote", iconName: "how_to_vote", suggestionTitle: "vote")
    
    let write = BlockDomain(keyWord: "write", iconName: "create", suggestionTitle: "write")
    let draw = BlockDomain(keyWord: "draw", iconName: "create", suggestionTitle: "draw")
    
    let shower = BlockDomain(keyWord: "shower", iconName: "waves", suggestionTitle: "have a shower")
    
    let swim = BlockDomain(keyWord: "swim", iconName: "pool", suggestionTitle: "swimming")
    
    let tv = BlockDomain(keyWord: "tv", iconName: "tv", suggestionTitle: "watch tv")
    
    let music = BlockDomain(keyWord: "music", iconName: "music_note", suggestionTitle: "music")
    let guitar = BlockDomain(keyWord: "guitar", iconName: "music_note", suggestionTitle: "guitar")
    let piano = BlockDomain(keyWord: "piano", iconName: "music_note", suggestionTitle: "piano")
    
    let paint = BlockDomain(keyWord: "paint", iconName: "brush", suggestionTitle: "paint")
    
    let design = BlockDomain(keyWord: "design", iconName: "palette", suggestionTitle: "design")
    
    let walk = BlockDomain(keyWord: "walk", iconName: "nature_people", suggestionTitle: "go for a walk")
    
    let morning = BlockDomain(keyWord: "morning", iconName: "wb_sunny", suggestionTitle: "morning routine")
    
    let drive = BlockDomain(keyWord: "drive", iconName: "directions_car", suggestionTitle: "drive")
    
    let run = BlockDomain(keyWord: "run", iconName: "directions_run", suggestionTitle: "go for a run")
    
    let bus = BlockDomain(keyWord: "bus", iconName: "directions_bus", suggestionTitle: "get the bus")
    
    let train = BlockDomain(keyWord: "train", iconName: "directions_train", suggestionTitle: "get the train")
    
    let flight = BlockDomain(keyWord: "flight", iconName: "flight", suggestionTitle: "flight")
    
    let sleep = BlockDomain(keyWord: "sleep", iconName: "hotel", suggestionTitle: "sleep")
    let nap = BlockDomain(keyWord: "nap", iconName: "hotel", suggestionTitle: "have a nap")
    
    let party = BlockDomain(keyWord: "party", iconName: "local_bar", suggestionTitle: "party")
    
    let coffee = BlockDomain(keyWord: "coffee", iconName: "local_cafe", suggestionTitle: "have a coffee")
    
    let laundry = BlockDomain(keyWord: "laundry", iconName: "local_laundry", suggestionTitle: "do laundry")
    
    let meditate = BlockDomain(keyWord: "meditate", iconName: "local_florist", suggestionTitle: "meditate")
    let yoga = BlockDomain(keyWord: "yoga", iconName: "local_florist", suggestionTitle: "yoga")
    
    let eat = BlockDomain(keyWord: "eat", iconName: "restaurant", suggestionTitle: "eat food")
    let cook = BlockDomain(keyWord: "cook", iconName: "restaurant", suggestionTitle: "cook food")
    let breakfast = BlockDomain(keyWord: "breakfast", iconName: "restaurant", suggestionTitle: "have breakfast")
    let lunch = BlockDomain(keyWord: "lunch", iconName: "restaurant", suggestionTitle: "have lunch")
    let dinner = BlockDomain(keyWord: "dinner", iconName: "restaurant", suggestionTitle: "have dinner")
    
    let exercise = BlockDomain(keyWord: "exercise", iconName: "fitness_center", suggestionTitle: "exercise")
    let gym = BlockDomain(keyWord: "gym", iconName: "fitness_center", suggestionTitle: "go to the gym")
    
    let golf = BlockDomain(keyWord: "golf", iconName: "golf_course", suggestionTitle: "golf")
    
    let competition = BlockDomain(keyWord: "competition", iconName: "emoji_events", suggestionTitle: "competition")
    
    let meeting = BlockDomain(keyWord: "meeting", iconName: "group", suggestionTitle: "meeting")
    
    let school = BlockDomain(keyWord: "school", iconName: "school", suggestionTitle: "school")
    let lecture = BlockDomain(keyWord: "lecture", iconName: "school", suggestionTitle: "class")
    let study = BlockDomain(keyWord: "study", iconName: "school", suggestionTitle: "study")
    let homework = BlockDomain(keyWord: "homework", iconName: "school", suggestionTitle: "homework")
    let exam = BlockDomain(keyWord: "exam", iconName: "school", suggestionTitle: "exam")
    
    let baseball = BlockDomain(keyWord: "baseball", iconName: "sports_baseball", suggestionTitle: "baseball")
    
    let basketball = BlockDomain(keyWord: "basketball", iconName: "sports_basketball", suggestionTitle: "basketball")
    
    let cricket = BlockDomain(keyWord: "cricket", iconName: "sports_cricket", suggestionTitle: "cricket")
    
    let hockey = BlockDomain(keyWord: "hockey", iconName: "sports_hockey", suggestionTitle: "hockey")
    
    let rugby = BlockDomain(keyWord: "rugby", iconName: "sports_rugby", suggestionTitle: "rugby")
    
    let football = BlockDomain(keyWord: "football", iconName: "sports_soccer", suggestionTitle: "football")
    
    let tennis = BlockDomain(keyWord: "tennis", iconName: "sports_tennis", suggestionTitle: "tennis")
    
    let volleyball = BlockDomain(keyWord: "volleyball", iconName: "sports_volleyball", suggestionTitle: "volleyball")
    
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
        let allDomains = [wake, read, book, quran, code, commute, home, shopping, store, movie, work, call, email, vote, write, draw, shower, swim, tv, music, guitar, piano, paint, design, walk, morning, drive, run, bus, train, flight, sleep, nap, party, coffee, laundry, meditate, yoga, eat, cook, breakfast, lunch, dinner, exercise, gym, golf, competition, meeting, school, lecture, study, homework, exam, baseball, basketball, cricket, hockey, rugby, football, tennis, volleyball]
        var determinedDomain: BlockDomain?
        var rating = 0.0
        
        guard let embedding = NLEmbedding.wordEmbedding(for: .english) else { return nil }
        
        for domain in allDomains {
            // Check if the word directly matches the keyword of the domain in the loop
            if domain.keyWord == word {
                determinedDomain = domain
                rating = 1
                break
            }
            
            embedding.enumerateNeighbors(for: domain.keyWord, maximumCount: 25) { (string, distance) -> Bool in
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
        
        // If a domain was found, return it with the rating, otherwise return nil
        if let domain = determinedDomain {
            return (domain: domain, rating: rating)
        } else {
            return nil
        }
    }
}

struct BlockDomain: Hashable {
    
    let keyWord: String
    let iconName: String
    let suggestionTitle: String
}
