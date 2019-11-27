//
//  SuggestionsStore.swift
//  neon
//
//  Created by James Saeed on 04/11/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import Foundation

class SuggestionsStore: ObservableObject {
    
    @Published var list = [Suggestion]()
    
    func load(for hour: Int) {
        DispatchQueue.global(qos: .userInteractive).async {
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
                return Suggestion(title: DomainsGateway.shared.domains[frequencies.key]!.suggestionTitle, reason: "Frequently Added", score: frequencies.value)
            }
            .sorted { $0.score > $1.score }
//            .prefix(upTo: 3)
            
            DispatchQueue.main.async { self.list = Array(suggestions) }
        }
    }
}

struct Suggestion: Hashable {
    
    var title: String
    var reason: String
    var score: Int
}
