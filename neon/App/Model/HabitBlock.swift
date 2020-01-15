//
//  Habit.swift
//  neon
//
//  Created by James Saeed on 17/11/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import Foundation

import SwiftUI
import Combine
import CoreData

struct HabitBlock: Identifiable {
    
    let id: String
    
    let title: String
    var lastDay: Date
    var completedToday: Bool
    
    var streak: Int
    var streakDescription: String {
        return streak == 0 ? "not started" : "\(streak) day streak"
    }
    
    init(title: String) {
        self.id = UUID().uuidString
        
        self.title = title
        self.streak = 0
        self.lastDay = Date()
        self.completedToday = false
    }
    
    init?(fromEntity entity: HabitBlockEntity) {
        guard let entityIdentifier = entity.identifier else { return nil }
        self.id = entityIdentifier
        
        guard let entityTitle = entity.title else { return nil }
        self.title = entityTitle
        
        self.streak = Int(entity.streak)
        
        guard let entityLastDay = entity.lastDay else { return nil }
        self.lastDay = entityLastDay
        
        self.completedToday = entity.completedToday
        
        refresh()
    }
    
    @discardableResult
    func getEntity(context: NSManagedObjectContext) -> HabitBlockEntity {
        let entity = HabitBlockEntity(context: context)
        entity.identifier = id
        entity.title = title
        entity.streak = Int64(streak)
        entity.lastDay = lastDay
        entity.completedToday = completedToday
        
        return entity
    }
    
    mutating func complete() {
        streak = streak + 1
        lastDay = Date()
        completedToday = true
    }
    
    mutating func refresh() {
        let lastDayComponent = Calendar.current.component(.day, from: lastDay)
        let currentDayComponent = Calendar.current.component(.day, from: Date())
        
        if (currentDayComponent - lastDayComponent) > 0 {
            completedToday = false
        }
        
        if (currentDayComponent - lastDayComponent) > 1 {
            streak = 0
        }
    }
}
