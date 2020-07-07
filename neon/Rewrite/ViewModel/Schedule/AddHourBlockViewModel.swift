//
//  AddHourBlockViewModel.swift
//  neon6
//
//  Created by James Saeed on 27/06/2020.
//

import Foundation

class AddHourBlockViewModel: ObservableObject {
    
    let dataGateway: NewDataGateway
    
    @Published var currentSuggestions = [Suggestion]()
    
    init(dataGateway: NewDataGateway) {
        self.dataGateway = dataGateway
    }
    
    convenience init() {
        self.init(dataGateway: NewDataGateway())
    }
    
    func loadSuggestions(for hour: Int, on day: Date) {
        DispatchQueue.global(qos: .userInitiated).async {
            let pulledSuggestions = SuggestionsGateway.shared.getSuggestions(for: hour, on: day)
            
            DispatchQueue.main.async {
                self.currentSuggestions = pulledSuggestions
            }
        }
    }
    
    func add(_ hourBlock: NewHourBlock) {
        dataGateway.saveHourBlock(block: hourBlock)
    }
}
