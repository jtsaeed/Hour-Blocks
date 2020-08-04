//
//  NewHourBlock.swift
//  Hour Blocks
//
//  Created by James Saeed on 01/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import Foundation
import CoreData

struct HourBlock {
    
    let id: String
    
    let title: String?
    let day: Date
    let hour: Int
    
    init(day: Date, hour: Int, title: String?) {
        self.id = UUID().uuidString
        
        self.title = title
        self.day = Calendar.current.startOfDay(for: day)
        self.hour = hour
    }
    
    init?(fromEntity entity: HourBlockEntity) {
        guard let entityIdentifier = entity.identifier else { return nil }
        guard let entityDay = entity.day else { return nil }
        guard let entityTitle = entity.title else { return nil }
        
        self.id = entityIdentifier
        
        self.title = entityTitle
        self.day = entityDay
        self.hour = Int(entity.hour)
    }
    
    @discardableResult
    func getEntity(context: NSManagedObjectContext) -> HourBlockEntity {
        let entity = HourBlockEntity(context: context)
        
        entity.identifier = id
        
        entity.title = title
        entity.day = day
        entity.hour = Int64(hour)
        
        return entity
    }
}
