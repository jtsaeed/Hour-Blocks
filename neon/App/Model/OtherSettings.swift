//
//  OtherSettings.swift
//  neon
//
//  Created by James Saeed on 21/02/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import Foundation
import CoreData

struct OtherSettings {
    
    var timeFormat: Int
    var reminderTimer: Int
    var autoCaps: Int
    var dayStart: Int
    
    init(timeFormat: Int, reminderTimer: Int, autoCaps: Int, dayStart: Int) {
        self.timeFormat = timeFormat
        self.reminderTimer = reminderTimer
        self.autoCaps = autoCaps
        self.dayStart = dayStart
    }
    
    init?(fromEntity entity: OtherSettingsEntity) {
        self.timeFormat = Int(entity.timeFormat)
        self.reminderTimer = Int(entity.reminderTimer)
        self.autoCaps = Int(entity.autoCaps)
        self.dayStart = Int(entity.dayStart)
    }
    
    @discardableResult
    func getEntity(context: NSManagedObjectContext) -> OtherSettingsEntity {
        let entity = OtherSettingsEntity(context: context)
        entity.timeFormat = Int64(timeFormat)
        entity.reminderTimer = Int64(reminderTimer)
        entity.autoCaps = Int64(autoCaps)
        entity.dayStart = Int64(dayStart)
        
        return entity
    }
}
