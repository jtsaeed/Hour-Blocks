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
    
    @Published var toDoItems = [ToDoItem]()
    
    @Published var isAddToDoItemViewPresented = false
    
    init(dataGateway: DataGateway) {
        self.dataGateway = dataGateway
        
        loadToDoItems()
    }
    
    convenience init() {
        self.init(dataGateway: DataGateway())
    }
    
    func loadToDoItems() {
        toDoItems = dataGateway.getToDoItems()
    }
    
    func add(toDoItem: ToDoItem) {
        dataGateway.saveToDoItem(toDoItem: toDoItem)
        
        toDoItems.append(toDoItem)
        toDoItems.sort()
    }
    
    func presentAddToDoItemView() {
        isAddToDoItemViewPresented = true
    }
    
    func dismissAddToDoItemView() {
        isAddToDoItemViewPresented = false
    }
}
