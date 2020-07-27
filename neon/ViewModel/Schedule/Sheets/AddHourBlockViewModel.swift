//
//  AddHourBlockViewModel.swift
//  neon6
//
//  Created by James Saeed on 27/06/2020.
//

import Foundation

class AddHourBlockViewModel: ObservableObject {
    
    let dataGateway: DataGateway
    
    @Published var currentSuggestions = [Suggestion]()
    
    init(dataGateway: DataGateway) {
        self.dataGateway = dataGateway
    }
    
    convenience init() {
        self.init(dataGateway: DataGateway())
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
    
    func add(_ hourBlock: HourBlock) {
        dataGateway.saveHourBlock(block: hourBlock)
    }
}
