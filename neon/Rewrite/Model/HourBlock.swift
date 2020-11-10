//
//  NewHourBlock.swift
//  Hour Blocks
//
//  Created by James Saeed on 01/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import Foundation
import CoreData

/// The model for an Hour Block.
struct HourBlock: Identifiable {
    
    let id: String
    
    private(set) var title: String?
    let day: Date
    let hour: Int
    
    private(set) var icon: SelectableIcon
    
    /// Creates an instance of an Hour Block.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the instance. By default, this is set to a generated UUID.
    ///   - day: The day this Hour Block is scheduled for.
    ///   - hour: The hour this Hour Blocks is scheduled for.
    ///   - title: The raw, user-inputted title of the Hour Block.
    ///   - icon: The icon of the Hour Block to be displayed.
    init(id: String = UUID().uuidString, day: Date, hour: Int, title: String?, icon: SelectableIcon) {
        self.id = id
        self.title = title
        self.day = Calendar.current.startOfDay(for: day)
        self.hour = hour
        self.icon = icon
    }
    
    /// Creates an instance of an Hour Block with the icon automatically determined from the title.
    ///
    /// - Parameters:
    ///   - day: The day this Hour Block is scheduled for.
    ///   - hour: The hour this Hour Blocks is scheduled for.
    ///   - title: The raw, user-inputted title of the Hour Block.
    init(day: Date, hour: Int, title: String) {
        let icon = DomainsGateway.shared.determineDomain(for: title)?.icon ?? .blocks
        self.init(day: day, hour: hour, title: title, icon: icon)
    }
    
    /// Creates an instance of an Hour Block from a Core Data entity.
    ///
    /// - Parameters:
    ///   - entity: The HourBlockEntity instance from the Core Data store.
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
    
    /// Creates an HourBlockEntity from the instance to be used with Core Data.
    ///
    /// - Returns:
    /// An instance of HourBlockEntity.
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
    
    /// Updates the instance's title property.
    ///
    /// - Parameters:
    ///   - newTitle: The new title to be updated.
    mutating func changeTitle(to newTitle: String) {
        title = newTitle
    }
    
    /// Updates the instance's icon property.
    ///
    /// - Parameters:
    ///   - newIcon: The new icon to be updated.
    mutating func changeIcon(to newIcon: SelectableIcon) {
        icon = newIcon
    }
}
