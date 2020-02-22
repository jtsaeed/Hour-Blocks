//
//  HourBlock.swift
//  neon3
//
//  Created by James Saeed on 18/06/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import SwiftUI
import Combine
import CoreData
import EventKit

struct HourBlock: Identifiable {
    
    let id: String
    let day: Date
    let hour: Int
    
    var title: String?
    var domain: BlockDomain?
    var iconOverride: String?
    var calendarEvent: EKEvent?
    
    var hasReminder = false
    var isSubBlock = false
    
    init(day: Date, hour: Int, title: String?) {
        self.id = UUID().uuidString
        self.day = Calendar.current.startOfDay(for: day)
        self.hour = hour
        
        self.title = title
        self.domain = DomainsGateway.shared.determineDomain(for: title)
    }
    
    init?(fromEntity entity: HourBlockEntity) {
        guard let entityIdentifier = entity.identifier else { return nil }
        
        self.id = entityIdentifier
        self.day = entity.day!
        self.hour = Int(entity.hour)
        self.title = entity.title
        self.domain = DomainsGateway.shared.determineDomain(for: title)
        self.iconOverride = entity.iconOverride
        
        self.hasReminder = entity.hasReminder
        self.isSubBlock = entity.isSubBlock
    }
    
    var formattedTime: String {
        if let otherSettingsEntity = DataGateway.shared.getOtherSettingsEntity() {
            if let timeFormatSetting = OtherSettings(fromEntity: otherSettingsEntity)?.timeFormat {
                if timeFormatSetting == 0 {
                    return DataGateway.shared.isSystemClock12h() ? hour.get12hTime() : hour.get24hTime()
                } else if timeFormatSetting == 1 {
                    return hour.get12hTime()
                } else if timeFormatSetting == 2 {
                    return hour.get24hTime()
                }
            }
        }
        
        return hour.get12hTime()
    }
    
    var iconName: String {
        if let icon = iconOverride {
            return icon
        } else {
            return domain?.iconName ?? "default"
        }
    }
    
    @discardableResult
    func getEntity(context: NSManagedObjectContext) -> HourBlockEntity {
        let entity = HourBlockEntity(context: context)
        entity.identifier = id
        entity.title = title
        entity.day = day
        entity.hour = Int64(hour)
        entity.isSubBlock = isSubBlock
        entity.iconOverride = iconOverride
        entity.hasReminder = hasReminder
        
        return entity
    }
    
    @discardableResult
    func getInMemoryEntity() -> HourBlockEntity {
        let entity = HourBlockEntity()
        entity.identifier = id
        entity.title = title
        entity.day = day
        entity.hour = Int64(hour)
        entity.isSubBlock = isSubBlock
        entity.iconOverride = iconOverride
        entity.hasReminder = hasReminder
        
        return entity
    }
}
