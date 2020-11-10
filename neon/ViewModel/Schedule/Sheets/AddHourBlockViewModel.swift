//
//  AddHourBlockViewModel.swift
//  neon6
//
//  Created by James Saeed on 27/06/2020.
//

import Foundation

/// The view model for the AddHourBlockView.
class AddHourBlockViewModel: ObservableObject {
    
    private let dataGateway: DataGateway
    private let analyticsGateway: AnalyticsGatewayProtocol
    
    @Published var currentSuggestions = [Suggestion]()
    
    /// Creates an instance of the AddHourBlockViewModel.
    ///
    /// - Parameters:
    ///   - dataGateway: The data gateway instance used to interface with Core Data. By default, this is set to an instance of DataGateway.
    ///   - analyticsGateway: The analytics gateway instance used to interface with Firebase Analytics. By default, this is set to an instance of AnalyticsGateway.
    init(dataGateway: DataGateway = DataGateway(), analyticsGateway: AnalyticsGatewayProtocol = AnalyticsGateway()) {
        self.dataGateway = dataGateway
        self.analyticsGateway = analyticsGateway
    }
    
    /// Loads suggestions for the current empty Hour Block from the SuggestionsGateway.
    ///
    /// - Parameters:
    ///   - hour: The hour of the current empty Hour Block.
    ///   - day: The day of the current empty Hour Block.
    func loadSuggestions(for hour: Int, on day: Date) {
        // Suggestions are loaded in a background thread as to not cause a delay in the AddHourBlockView being presented
        DispatchQueue.global(qos: .userInitiated).async {
            let pulledSuggestions = SuggestionsGateway.shared.getSuggestions(for: hour,
                                                                             on: day,
                                                                             with: self.dataGateway)
            
            // Once the suggestions are loaded, they're then pushed to the UI on the main thread
            DispatchQueue.main.async { self.currentSuggestions = pulledSuggestions }
        }
    }
    
    /// Logs an added suggestion to analytics.
    ///
    /// - Parameters:
    ///   - suggestion: The added suggestion.
    func logAddedSuggestion(_ suggestion: Suggestion) {
        analyticsGateway.log(suggestion: suggestion)
    }
}
