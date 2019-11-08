//
//  ToDoItem.swift
//  neon3
//
//  Created by James Saeed on 19/06/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import SwiftUI
import Combine
import CoreData

struct ToDoItem: Hashable, Comparable {
    
    let identifier: String
    let title: String
    let priority: ToDoPriority
    
    init(title: String, priority: ToDoPriority) {
        self.identifier = UUID().uuidString
        self.title = title
        self.priority = priority
    }
    
    init(fromEntity entity: ToDoEntity) {
        self.identifier = entity.identifier!
        self.title = entity.title!
        self.priority = ToDoPriority(rawValue: entity.priority!)!
    }
    
    func getEntity(context: NSManagedObjectContext) {
        let entity = ToDoEntity(context: context)
        entity.identifier = identifier
        entity.title = title
        entity.priority = priority.rawValue
    }
    
    static func < (lhs: ToDoItem, rhs: ToDoItem) -> Bool {
        if lhs.priority == .none && (rhs.priority == .low || rhs.priority == .medium || rhs.priority == .high) {
            return true
        } else if lhs.priority == .low && (rhs.priority == .medium || rhs.priority == .high) {
            return true
        } else if lhs.priority == .medium && rhs.priority == .high {
            return true
        } else {
            return false
        }
    }
}

class ToDoItemsStore: ObservableObject {
    
    @Published var toDoItems = [ToDoItem]()
    
    init() {
        for entity in DataGateway.shared.getToDoEntities() {
            toDoItems.append(ToDoItem(fromEntity: entity))
        }
    }
    
    func addToDoItem(with title: String, _ priority: ToDoPriority) {
        let toDoItem = ToDoItem(title: title, priority: priority)
        
        toDoItems.append(toDoItem)
        DataGateway.shared.saveToDo(toDo: toDoItem)
    }
    
    func removeToDoItem(toDo: ToDoItem) {
        for i in 0 ..< toDoItems.count {
            if toDo.identifier == toDoItems[i].identifier {
                toDoItems.remove(at: i)
                break
            }
        }
        
        DataGateway.shared.deleteToDo(toDo: toDo)
    }
}

enum ToDoPriority: String {
    
    case high = "HIGH PRIORITY"
    case medium = "MED PRIORITY"
    case low = "LOW PRIORITY"
    case none = "NO PRIORITY"
}
