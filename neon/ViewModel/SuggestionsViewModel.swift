//
//  SuggestionsStore.swift
//  neon
//
//  Created by James Saeed on 04/11/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import SwiftUI

/*
class SuggestionsViewModel: ObservableObject {
    
    @Published var list = [Suggestion]()
    
    func load(for hour: Int) {
        DispatchQueue.global(qos: .userInteractive).async {
            let frequentlyAdded = self.frequentlyAddedSuggestions(for: hour)
            let dateBased = self.dateBasedSuggestions()
            
            DispatchQueue.main.async { self.list = frequentlyAdded + dateBased }
        }
    }
    
    private func frequentlyAddedSuggestions(for hour: Int) -> [Suggestion] {
        let storedSuggestions: [SuggestionEntity] = DataGateway.shared.getSuggestionEntities().filter { entity in
            return Int(entity.hour) == hour
        }
                    
        let pastMonthFrequencies = storedSuggestions.reduce(into: [String: Int]()) {
            if Calendar.current.isDate(Date(), equalTo: $1.date!, toGranularity: .month) {
                if let pastMonthFrequency = $0[$1.domainKey!] {
                    $0[$1.domainKey!] = pastMonthFrequency + 1
                } else {
                    $0[$1.domainKey!] = 1
                }
            }
        }
        .filter { $0.value >= 3 }
                    
        let suggestions = pastMonthFrequencies.map { frequencies in
            return Suggestion(title: "", reason: "Frequently Added", score: frequencies.value)
        }
        .sorted { $0.score! > $1.score! }
//        .prefix(upTo: 3)
        
        return suggestions
    }
    
    private func dateBasedSuggestions() -> [Suggestion] {
        var suggestions = [Suggestion]()
        
        let calendar = Calendar.current
        let date = Date()
        
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        if day == 12 && month == 12 && year == 2019 && Locale.current.regionCode! == "GB" {
            suggestions.append(Suggestion(title: "Vote", reason: "Based on Date", score: nil))
        }
        
        return suggestions
    }
}
*/
