//
//  NewToDoListViewModel.swift
//  Hour Blocks
//
//  Created by James Saeed on 05/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI
import WidgetKit

/// The view model for the ToDoListView.
class ToDoListViewModel: ObservableObject {
    
    private let dataGateway: DataGateway
    private let analyticsGateway: AnalyticsGatewayProtocol
    
    /// A UserDefaults property of the total count of To Do items the user has added.
    @AppStorage("totalToDoCount") private var totalToDoCount = 0
    
    @Published private(set) var toDoItems = [ToDoItemViewModel]()
    @Published private(set) var currentTip: Tip?
    
    @Published var isAddToDoItemViewPresented = false
    
    /// Creates an instance of the ToDoListViewModel and then loads the user's To Do items.
    ///
    /// - Parameters:
    ///   - dataGateway: The data gateway instance used to interface with Core Data. By default, this is set to an instance of DataGateway.
    ///   - analyticsGateway: The analytics gateway instance used to interface with Firebase Analytics. By default, this is set to an instance of AnalyticsGateway.
    init(dataGateway: DataGateway = DataGateway(), analyticsGateway: AnalyticsGatewayProtocol = AnalyticsGateway()) {
        self.dataGateway = dataGateway
        self.analyticsGateway = analyticsGateway
        
        loadToDoItems()
    }
}

// MARK: - To Do Item Operations

extension ToDoListViewModel {
    
    /// Loads the user's To Do items from the Core Data store and then sorts them.
    func loadToDoItems() {
        toDoItems = dataGateway.getToDoItems().map { ToDoItemViewModel(for: $0) }
        sortToDoItems()
    }
    
    /// Adds a given To Do item to the Core Data store and the view model.
    ///
    /// - Parameters:
    ///   - toDoItem: The To Do item to be added.
    func add(toDoItem: ToDoItem) {
        HapticsGateway.shared.triggerAddBlockHaptic()
        
        dataGateway.save(toDoItem: toDoItem)
        analyticsGateway.logToDoItem()
        
        withAnimation {
            toDoItems.append(ToDoItemViewModel(for: toDoItem))
            sortToDoItems()
        }
        
        handleToDoCountEvents()
        WidgetCenter.shared.reloadTimelines(ofKind: "ToDoWidget")
    }
    
    /// Removes a given To Do item from the Core Data store and the view model.
    ///
    /// - Parameters:
    ///   - toDoItem: The To Do item to be removed.
    func clear(toDoItem: ToDoItem) {
        HapticsGateway.shared.triggerCompletionHaptic()
        
        dataGateway.delete(toDoItem: toDoItem)
        toDoItems.removeAll(where: { $0.toDoItem.id == toDoItem.id })
        
        WidgetCenter.shared.reloadAllTimelines()
    }
}

// MARK: - Miscellaneous Functionality

extension ToDoListViewModel {
    
    /// Presents the AddToDoItemView.
    func presentAddToDoItemView() {
        HapticsGateway.shared.triggerLightImpact()
        isAddToDoItemViewPresented = true
    }
    
    /// Dismisses the AddToDoItemView.
    func dismissAddToDoItemView() {
        isAddToDoItemViewPresented = false
    }
    
    /// Sets the current tip to be nil, resulting in the current tip card being dismissed from the To Do List view.
    func dismissTip() {
        HapticsGateway.shared.triggerLightImpact()
        setCurrentTip(as: nil)
    }
}

// MARK: - Private Functionality

extension ToDoListViewModel {
    
    /// Sorts the loaded To Do items by title, then priority
    private func sortToDoItems() {
        toDoItems.sort(by: { $0.toDoItem.title > $1.toDoItem.title })
        toDoItems.sort()
    }
    
    /// Increases the total count of To Do items added by 1, then performs any to do item count related events.
    private func handleToDoCountEvents() {
        totalToDoCount = totalToDoCount + 1
        
        if totalToDoCount == 2 { setCurrentTip(as: .blockOptions) }
        if totalToDoCount == 5 { setCurrentTip(as: .toDoSiri) }
    }
    
    /// Sets the current tip to a given tip.
    ///
    /// - Parameters:
    ///   - tip: The tip to be set as the current tip.
    private func setCurrentTip(as tip: Tip?) {
        withAnimation { currentTip = tip }
    }
}
