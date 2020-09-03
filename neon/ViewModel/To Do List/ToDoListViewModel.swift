//
//  NewToDoListViewModel.swift
//  Hour Blocks
//
//  Created by James Saeed on 05/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

class ToDoListViewModel: ObservableObject {
    
    let dataGateway: DataGateway
    let analyticsGateway: AnalyticsGatewayProtocol
    
    @AppStorage("totalToDoCount") var totalToDoCount = 0
    
    @Published var toDoItems = [ToDoItemViewModel]()
    
    @Published var currentTip: Tip?
    
    @Published var isAddToDoItemViewPresented = false
    
    init(dataGateway: DataGateway, analyticsGateway: AnalyticsGatewayProtocol) {
        self.dataGateway = dataGateway
        self.analyticsGateway = analyticsGateway
        
        loadToDoItems()
    }
    
    convenience init() {
        self.init(dataGateway: DataGateway(), analyticsGateway: AnalyticsGateway())
    }
    
    func loadToDoItems() {
        toDoItems = dataGateway.getToDoItems().map { ToDoItemViewModel(for: $0) }
        sortToDoItems()
    }
    
    func add(toDoItem: ToDoItem) {
        HapticsGateway.shared.triggerAddBlockHaptic()
        
        dataGateway.save(toDoItem: toDoItem)
        analyticsGateway.logToDoItem()
        
        withAnimation {
            toDoItems.append(ToDoItemViewModel(for: toDoItem))
            sortToDoItems()
        }
        
        totalToDoCount = totalToDoCount + 1
        if totalToDoCount == 2 { withAnimation { currentTip = .blockOptions } }
        if totalToDoCount == 5 { withAnimation { currentTip = .toDoSiri } }
    }
    
    func clear(toDoItem: ToDoItem) {
        HapticsGateway.shared.triggerClearBlockHaptic()
        
        dataGateway.delete(toDoItem: toDoItem)
        
        toDoItems.removeAll(where: { $0.toDoItem.id == toDoItem.id })
    }
    
    func dismissTip() {
        HapticsGateway.shared.triggerLightImpact()
        withAnimation { currentTip = nil }
    }
    
    func presentAddToDoItemView() {
        HapticsGateway.shared.triggerLightImpact()
        isAddToDoItemViewPresented = true
    }
    
    func dismissAddToDoItemView() {
        isAddToDoItemViewPresented = false
    }
}

extension ToDoListViewModel {
    
    private func sortToDoItems() {
        toDoItems.sort(by: { $0.toDoItem.title > $1.toDoItem.title })
        toDoItems.sort()
    }
}
