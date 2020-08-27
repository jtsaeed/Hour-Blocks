//
//  NewHourBlock.swift
//  Hour Blocks
//
//  Created by James Saeed on 01/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import Foundation
import CoreData

struct HourBlock: Identifiable {
    
    let id: String
    
    private(set) var title: String?
    let day: Date
    let hour: Int
    
    private(set) var icon: SelectableIcon
    
    init(id: String, day: Date, hour: Int, title: String?, icon: SelectableIcon) {
        self.id = id
        
        self.title = title
        self.day = Calendar.current.startOfDay(for: day)
        self.hour = hour
        
        self.icon = icon
    }
    
    init(day: Date, hour: Int, title: String?, icon: SelectableIcon) {
        self.init(id: UUID().uuidString, day: day, hour: hour, title: title, icon: icon)
    }
    
    init(day: Date, hour: Int, title: String) {
        let icon = DomainsGateway.shared.determineDomain(for: title)?.icon ?? .blocks
        
        self.init(day: day, hour: hour, title: title, icon: icon)
    }
    
    init?(fromEntity entity: HourBlockEntity) {
        guard let entityIdentifier = entity.identifier else { return nil }
        guard let entityDay = entity.day else { return nil }
        guard let entityTitle = entity.title else { return nil }
        
        self.id = entityIdentifier
        
        self.title = entityTitle
        self.day = entityDay
        self.hour = Int(entity.hour)
        
        if let entityIconName = entity.iconOverride {
            self.icon = SelectableIcon(rawValue: entityIconName) ?? .blocks
        } else {
            self.icon = .blocks
        }
    }
    
    @discardableResult
    func getEntity(context: NSManagedObjectContext) -> HourBlockEntity {
        let entity = HourBlockEntity(context: context)
        
        entity.identifier = id
        
        entity.title = title
        entity.day = day
        entity.hour = Int64(hour)
        entity.iconOverride = icon.rawValue
        
        return entity
    }
    
    mutating func changeTitle(to title: String) {
        self.title = title
    }
    
    mutating func changeIcon(to icon: SelectableIcon) {
        self.icon = icon
    }
}
