//
//  SuggestionsGateway.swift
//  Hour Blocks
//
//  Created by James Saeed on 01/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import Foundation

/// A singleton gateway service used to interface with the Hour Blocks suggestions framework.
struct SuggestionsGateway {
    
    static let shared = SuggestionsGateway()
    
    /// Retrieves the suggestions for a given hour and day.
    ///
    /// - Parameters:
    ///   - hour: The hour to match suggestions for.
    ///   - day: The day to match suggestions for.
    ///   - dataGateway: The instance of DataGateway to retrieve frequently added Hour Blocks from.
    ///
    /// - Returns:
    /// An array of suggestions.
    func getSuggestions(for hour: Int, on day: Date, with dataGateway: DataGateway) -> [Suggestion] {
        var suggestions = [Suggestion]()
        
        // Get all possible suggestions
        suggestions.append(contentsOf: getPopular(for: hour, on: day))
        suggestions.append(contentsOf: getFrequentlyAdded(for: hour, on: day, with: dataGateway, existingSuggestions: suggestions))
        
        // Sort by score
        suggestions = suggestions.sorted(by: { $0.score > $1.score })
        
        // Filter to the first 5 if necessary
        if suggestions.count > 5 { suggestions = suggestions.dropLast(suggestions.count - 5) }
        
        return suggestions
    }
    
    /// Retrieves the suggestions for frequently added Hour Blocks for a given hour and day.
    ///
    /// - Parameters:
    ///   - hour: The hour to match suggestions for.
    ///   - day: The day to match suggestions for.
    ///   - dataGateway: The instance of DataGateway to retrieve frequently added Hour Blocks from.
    ///   - existingSuggestions: An array of suggestions that already exist so as to not suggest any duplicates.
    ///
    /// - Returns:
    /// An array of suggestions.
    private func getFrequentlyAdded(for hour: Int, on day: Date, with dataGateway: DataGateway, existingSuggestions: [Suggestion]) -> [Suggestion] {
        let lastMonthsBlocks = dataGateway.getLastMonthsHourBlocks(from: day, for: hour)
        let lastMonthsDomains = lastMonthsBlocks.compactMap({ DomainsGateway.shared.determineDomain(for: $0.title!) })
        var lastMonthsDomainFrequencies = [BlockDomain: Int]()
        
        // Create a map of domains paired with a frequency value
        for domain in lastMonthsDomains {
            if existingSuggestions.contains(where: { $0.domain == domain }) { continue }
            lastMonthsDomainFrequencies[domain] = (lastMonthsDomainFrequencies[domain] ?? 0) + 1
        }
        
        // Return any domains with a frequency higher than 3
        return lastMonthsDomainFrequencies.compactMap({ key, value in
            guard value >= 3 else { return nil }
            return Suggestion(domain: key, reason: "frequently added", score: value + 10)
        })
    }
    
    /// Retrieves the suggestions for popular Hour Blocks for a given hour and day.
    ///
    /// - Parameters:
    ///   - hour: The hour to match suggestions for.
    ///   - day: The day to match suggestions for.
    ///
    /// - Returns:
    /// An array of suggestions.
    private func getPopular(for hour: Int, on day: Date) -> [Suggestion] {
        var suggestions = [Suggestion]()
        
        // Weekdays
        if day.weekday >= 2 && day.weekday <= 6 {
            if hour >= 9 && hour <= 17 {
                suggestions.append(Suggestion(domain: .work, reason: "popular", score: 5))
                suggestions.append(Suggestion(domain: .lecture, reason: "popular", score: 3))
            }
            
            if hour == 8 || hour == 17 {
                suggestions.append(Suggestion(domain: .commute, reason: "popular", score: 1))
            }
            
            if hour == 17 {
                suggestions.append(Suggestion(domain: .home, reason: "popular", score: 1))
            }
        }
        // Weekend
        if (day.weekday == 6 || day.weekday == 7) && (hour >= 19 && hour <= 21) {
            suggestions.append(Suggestion(domain: .party, reason: "popular", score: 1))
        }
        // Every day in the morning
        if hour >= 5 && hour <= 8 {
            suggestions.append(Suggestion(domain: .wake, reason: "popular", score: 2))
        }
        // Every day, a little after morning
        if hour >= 6 && hour <= 9 {
            suggestions.append(Suggestion(domain: .coffee, reason: "popular", score: 1))
            suggestions.append(Suggestion(domain: .breakfast, reason: "popular", score: 2))
        }
        // Every day at lunch
        if hour >= 11 && hour <= 14 {
            suggestions.append(Suggestion(domain: .lunch, reason: "popular", score: 4))
        }
        // Every day at dinner
        if hour >= 17 && hour <= 21 {
            suggestions.append(Suggestion(domain: .dinner, reason: "popular", score: 4))
        }
        // Every day in the evening
        if hour >= 18 && hour <= 22 {
            suggestions.append(Suggestion(domain: .relax, reason: "popular", score: 3))
        }
        // Every day at night sleep
        if hour >= 21 && hour <= 23 {
            suggestions.append(Suggestion(domain: .sleep, reason: "popular", score: 3))
        }
        
        return suggestions
    }
}
