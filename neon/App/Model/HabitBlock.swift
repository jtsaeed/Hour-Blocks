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

struct HabitBlock: Hashable {
    
    let identifier: String
    
    let title: String
    var lastDay: Date
    var completedToday: Bool
    
    private var streak: Int
    var streakDescription: String {
        return streak == 0 ? "not started" : "\(streak) day streak"
    }
    
    init(title: String) {
        self.identifier = UUID().uuidString
        
        self.title = title
        self.streak = 0
        self.lastDay = Date()
        self.completedToday = false
    }
    
    mutating func complete() {
        streak = streak + 1
        lastDay = Date()
        completedToday = true
    }
    
    mutating func refresh() {
        let lastDayComponent = Calendar.current.component(.day, from: lastDay)
        let currentDayComponent = Calendar.current.component(.day, from: Date())
        
        if (currentDayComponent - lastDayComponent) > 1 {
            streak = 0
            completedToday = false
        }
    }
    
    init(fromEntity entity: HabitBlockEntity) {
        self.identifier = entity.identifier!
        
        self.title = entity.title!
        self.streak = Int(entity.streak)
        self.lastDay = entity.lastDay!
        self.completedToday = entity.completedToday
    }
    
    @discardableResult
    func getEntity(context: NSManagedObjectContext) -> HabitBlockEntity {
        let entity = HabitBlockEntity(context: context)
        entity.identifier = identifier
        entity.title = title
        entity.streak = Int64(streak)
        entity.lastDay = lastDay
        entity.completedToday = completedToday
        
        return entity
    }
}
