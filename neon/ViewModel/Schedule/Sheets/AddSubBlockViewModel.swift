//
//  AddSubBlockViewModel.swift
//  Hour Blocks
//
//  Created by James Saeed on 03/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import Foundation

class AddSubBlockViewModel: ObservableObject {
    
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
