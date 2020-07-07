//
//  NewToDoListViewModel.swift
//  Hour Blocks
//
//  Created by James Saeed on 05/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import Foundation

class NewToDoListViewModel: ObservableObject {
    
    @Published var toDoItems = [ToDoItem]()
    
    func addToDoItem() {
        
    }
}
