//
//  UserCalendar.swift
//  neon
//
//  Created by James Saeed on 21/02/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import Foundation
import CoreData

struct UserCalendar {
    
    let identifier: String
    var enabled: Bool
    
    init(identifier: String, enabled: Bool) {
        self.identifier = identifier
        self.enabled = enabled
    }
    
    init?(fromEntity entity: UserCalendarEntity) {
        guard let entityIdentifier = entity.identifier else { return nil }
        
        self.identifier = entityIdentifier
        self.enabled = entity.enabled
    }
    
    @discardableResult
    func getEntity(context: NSManagedObjectContext) -> UserCalendarEntity {
        let entity = UserCalendarEntity(context: context)
        entity.identifier = identifier
        entity.enabled = enabled
        
        return entity
    }
}
