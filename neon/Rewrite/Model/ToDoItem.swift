//
//  ToDoItem.swift
//  neon
//
//  Created by James Saeed on 09/02/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import Foundation
import CoreData

struct ToDoItem: Identifiable {
    
    let id: String
    
    let completed: Bool
    let completionDate: Date?
    
    private(set) var title: String
    let urgency: ToDoUrgency
    
    /// Creates an instance of a To Do item.
    ///
    /// - Parameters:
    ///   - title: The raw, user-inputted title of the To Do item.
    ///   - urgency: The urgency of the To Do item.
    init(title: String, urgency: ToDoUrgency) {
        self.id = UUID().uuidString
        self.title = title
        self.urgency = urgency
        self.completed = false
        self.completionDate = nil
    }
    
    /// Creates an instance of a To Do item from a Core Data entity.
    ///
    /// - Parameters:
    ///   - entity: The ToDoEntity instance from the Core Data store.
    init?(fromEntity entity: ToDoEntity) {
        guard let entityIdentifier = entity.identifier else { return nil }
        guard let entityTitle = entity.title else { return nil }
        
        self.id = entityIdentifier
        self.title = entityTitle
        
        self.completed = entity.completed
        self.completionDate = entity.completionDate
        
        if let entityUrgency = entity.urgency {
            self.urgency = ToDoUrgency(rawValue: entityUrgency)!
        } else {
            self.urgency = .whenever
        }
    }
    
    /// Creates a ToDoEntity from the instance to be used with Core Data.
    ///
    /// - Returns:
    /// An instance of ToDoEntity.
    @discardableResult
    func getEntity(context: NSManagedObjectContext) -> ToDoEntity {
        let entity = ToDoEntity(context: context)
        
        entity.identifier = id
        entity.title = title
        entity.urgency = urgency.rawValue
        entity.completed = completed
        entity.completionDate = completionDate
        
        return entity
    }
    
    /// Updates the instance's title property.
    ///
    /// - Parameters:
    ///   - newTitle: The new title to be updated.
    mutating func changeTitle(to newTitle: String) {
        title = newTitle
    }
}
