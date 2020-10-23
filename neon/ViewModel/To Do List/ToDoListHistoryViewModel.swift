//
//  ToDoListHistoryViewModel.swift
//  Hour Blocks
//
//  Created by James Litchfield on 23/10/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI
import WidgetKit

/// The view model for the ToDoListHistoryView.
class ToDoListHistoryViewModel: ObservableObject {
    
    private let dataGateway: DataGateway
    
    @Published var completedToDoItems: [ToDoItemViewModel] = []
    
    /// Creates an instance of the ToDoListHistoryViewModel and then loads the user's To Do items.
    ///
    /// - Parameters:
    ///   - dataGateway: The data gateway instance used to interface with Core Data. By default, this is set to an instance of DataGateway.
    init(dataGateway: DataGateway = DataGateway()) {
        self.dataGateway = dataGateway
        
        loadCompletedToDoItems()
    }
    
    /// Loads the user's completed To Do items from the Core Data store.
    func loadCompletedToDoItems() {
        completedToDoItems = dataGateway.getCompletedToDoItems().map { ToDoItemViewModel(for: $0) }
    }
}
