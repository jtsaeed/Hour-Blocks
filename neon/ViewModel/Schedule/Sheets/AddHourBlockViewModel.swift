//
//  AddHourBlockViewModel.swift
//  neon6
//
//  Created by James Saeed on 27/06/2020.
//

import Foundation

class AddHourBlockViewModel: ObservableObject {
    
    let dataGateway: DataGateway
    let analyticsGateway: AnalyticsGateway
    
    @Published var currentSuggestions = [Suggestion]()
    
    init(dataGateway: DataGateway, analyticsGateway: AnalyticsGateway) {
        self.dataGateway = dataGateway
        self.analyticsGateway = analyticsGateway
    }
    
    convenience init() {
        self.init(dataGateway: DataGateway(), analyticsGateway: AnalyticsGateway())
    }
    
    func loadSuggestions(for hour: Int, on day: Date) {
        DispatchQueue.global(qos: .userInitiated).async {
            let pulledSuggestions = SuggestionsGateway.shared.getSuggestions(for: hour,
                                                                             on: day,
                                                                             with: self.dataGateway)
            
            DispatchQueue.main.async {
                self.currentSuggestions = pulledSuggestions
            }
        }
    }
    
    func logAddedSuggestion(_ suggestion: Suggestion) {
        analyticsGateway.log(suggestion: suggestion)
    }
}
