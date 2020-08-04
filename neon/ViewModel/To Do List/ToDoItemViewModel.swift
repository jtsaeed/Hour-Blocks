//
//  ToDoItemViewModel.swift
//  Hour Blocks
//
//  Created by James Saeed on 28/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import Foundation

class ToDoItemViewModel: ObservableObject, Identifiable {
    
    private let dataGateway: DataGateway
    
    let toDoItem: ToDoItem
    
    @Published var title: String
    @Published var urgency: String
    
    @Published var isEditItemViewPresented = false
    
    init(for toDoItem: ToDoItem, dataGateway: DataGateway) {
        self.dataGateway = dataGateway
        
        self.toDoItem = toDoItem
        self.title = toDoItem.title
        self.urgency = toDoItem.urgency.rawValue
    }
    
    convenience init(for toDoItem: ToDoItem) {
        self.init(for: toDoItem, dataGateway: DataGateway())
    }
    
    func presentEditItemView() {
        isEditItemViewPresented = true
    }
    
    func dismissEditItemView() {
        isEditItemViewPresented = false
    }
    
    func saveChanges(title: String, urgency: ToDoUrgency) {
        self.title = title
        self.urgency = urgency.rawValue
        
        dataGateway.edit(toDoItem: toDoItem, set: title, forKey: "title")
        dataGateway.edit(toDoItem: toDoItem, set: urgency.rawValue, forKey: "urgency")
        
        dismissEditItemView()
    }
}

extension ToDoItemViewModel: Comparable {
    
    static func == (lhs: ToDoItemViewModel, rhs: ToDoItemViewModel) -> Bool {
        return lhs.urgency == rhs.urgency
    }
    
    static func < (lhs: ToDoItemViewModel, rhs: ToDoItemViewModel) -> Bool {
        if lhs.toDoItem.urgency == .whenever && (rhs.toDoItem.urgency == .soon || rhs.toDoItem.urgency == .urgent) {
            return false
        } else if lhs.toDoItem.urgency == .soon && rhs.toDoItem.urgency == .urgent {
            return false
        } else {
            return true
        }
    }
}
