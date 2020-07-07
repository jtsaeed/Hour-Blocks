//
//  AddSubBlockViewModel.swift
//  Hour Blocks
//
//  Created by James Saeed on 03/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import Foundation

class AddSubBlockViewModel: ObservableObject {
    
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
