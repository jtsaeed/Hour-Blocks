//
//  SubBlock.swift
//  Hour Blocks
//
//  Created by James Saeed on 02/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import Foundation
import CoreData

struct SubBlock: Identifiable {
    
    let id: String
    private let hourBlockId: String
    
    let title: String
    private let timestamp: Date
    
    init(of hourBlock: HourBlock, title: String) {
        self.id = UUID().uuidString
        self.hourBlockId = hourBlock.id
        
        self.title = title
        self.timestamp = Date()
    }
    
    init?(fromEntity entity: SubBlockEntity) {
        guard let entityIdentifier = entity.identifier else { return nil }
        guard let entityHourBlockIdentifier = entity.hourBlockIdentifier else { return nil }
        guard let entityTitle = entity.title else { return nil }
        guard let entityTimestamp = entity.timestamp else { return nil }
        
        self.id = entityIdentifier
        self.hourBlockId = entityHourBlockIdentifier
        self.title = entityTitle
        self.timestamp = entityTimestamp
    }
    
    @discardableResult
    func getEntity(context: NSManagedObjectContext) -> SubBlockEntity {
        let entity = SubBlockEntity(context: context)
        
        entity.identifier = id
        entity.hourBlockIdentifier = hourBlockId
        entity.title = title
        entity.timestamp = timestamp
        
        return entity
    }
    
}
