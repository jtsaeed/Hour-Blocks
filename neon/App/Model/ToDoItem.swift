//
//  ToDoItem.swift
//  neon
//
//  Created by James Saeed on 09/02/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import Foundation
import CoreData

struct ToDoItem: Identifiable, Comparable {
    
    let id: String
    var title: String
    var urgency: ToDoUrgency
    
    init(title: String, urgency: ToDoUrgency) {
        self.id = UUID().uuidString
        self.title = title
        self.urgency = urgency
    }
    
    init?(fromEntity entity: ToDoEntity) {
        guard let entityIdentifier = entity.identifier else { return nil }
        
        self.id = entityIdentifier
        self.title = entity.title!
        
        if let entityUrgency = entity.urgency {
            self.urgency = ToDoUrgency(rawValue: entityUrgency)!
        } else {
            self.urgency = .whenever
        }
    }
    
    func getEntity(context: NSManagedObjectContext) {
        let entity = ToDoEntity(context: context)
        entity.identifier = id
        entity.title = title
        entity.urgency = urgency.rawValue
    }
    
    static func < (lhs: ToDoItem, rhs: ToDoItem) -> Bool {
        if lhs.urgency == .whenever && (rhs.urgency == .soon || rhs.urgency == .urgent) {
            return false
        } else if lhs.urgency == .soon && rhs.urgency == .urgent {
            return false
        } else {
            return true
        }
    }
}

enum ToDoUrgency: String {
    
    case urgent, soon, whenever
}
