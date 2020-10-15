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
    
    private(set) var title: String
    let urgency: ToDoUrgency
    
    init(title: String, urgency: ToDoUrgency) {
        self.id = UUID().uuidString
        self.title = title
        self.urgency = urgency
    }
    
    init?(fromEntity entity: ToDoEntity) {
        guard let entityIdentifier = entity.identifier else { return nil }
        guard let entityTitle = entity.title else { return nil }
        
        self.id = entityIdentifier
        self.title = entityTitle
        
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
    
    mutating func changeTitle(to title: String) {
        self.title = title
    }
}

enum ToDoUrgency: String, CaseIterable {
    
    case whenever, soon, urgent
}
