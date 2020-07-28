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
    
    @Published var toDoItems = [ToDoItemViewModel]()
    
    @Published var isAddToDoItemViewPresented = false
    
    init(dataGateway: DataGateway) {
        self.dataGateway = dataGateway
        
        loadToDoItems()
    }
    
    convenience init() {
        self.init(dataGateway: DataGateway())
    }
    
    func loadToDoItems() {
        toDoItems = dataGateway.getToDoItems().map { ToDoItemViewModel(for: $0) }
    }
    
    func add(toDoItem: ToDoItem) {
        dataGateway.saveToDoItem(toDoItem: toDoItem)
        
        toDoItems.append(ToDoItemViewModel(for: toDoItem))
        toDoItems.sort()
    }
    
    func clear(toDoItem: ToDoItem) {
        toDoItems.removeAll(where: { $0.toDoItem.id == toDoItem.id })
    }
    
    func presentAddToDoItemView() {
        isAddToDoItemViewPresented = true
    }
    
    func dismissAddToDoItemView() {
        isAddToDoItemViewPresented = false
    }
}
