//
//  NewToDoListViewModel.swift
//  Hour Blocks
//
//  Created by James Saeed on 05/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import Foundation

class ToDoListViewModel: ObservableObject {
    
    let dataGateway: DataGateway
    let analyticsGateway: AnalyticsGatewayProtocol
    
    @Published var toDoItems = [ToDoItemViewModel]()
    
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
    }
    
    func add(toDoItem: ToDoItem) {
        HapticsGateway.shared.triggerAddBlockHaptic()
        
        dataGateway.save(toDoItem: toDoItem)
        analyticsGateway.logToDoItem()
        
        toDoItems.append(ToDoItemViewModel(for: toDoItem))
        toDoItems.sort()
    }
    
    func clear(toDoItem: ToDoItem) {
        HapticsGateway.shared.triggerClearBlockHaptic()
        
        dataGateway.delete(toDoItem: toDoItem)
        
        toDoItems.removeAll(where: { $0.toDoItem.id == toDoItem.id })
    }
    
    func presentAddToDoItemView() {
        HapticsGateway.shared.triggerLightImpact()
        isAddToDoItemViewPresented = true
    }
    
    func dismissAddToDoItemView() {
        isAddToDoItemViewPresented = false
    }
}
