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
    var streak: Int
    var lastDay: Date
    
    init(title: String) {
        self.identifier = UUID().uuidString
        
        self.title = title
        self.streak = 0
        self.lastDay = Date()
    }
    
    var streakDescription: String {
        return streak == 0 ? "not started" : "\(streak) day streak"
    }
    
    mutating func incrementStreak() {
        streak = streak + 1
        lastDay = Date()
    }
    
    mutating func checkStreak() {
        let lastDayComponent = Calendar.current.component(.day, from: lastDay)
        let currentDayComponent = Calendar.current.component(.day, from: Date())
        
        if (currentDayComponent - lastDayComponent) > 1 {
            streak = 0
        }
    }
    
    init(fromEntity entity: HabitBlockEntity) {
        self.identifier = entity.identifier!
        
        self.title = entity.title!
        self.streak = Int(entity.streak)
        self.lastDay = entity.lastDay!
    }
    
    @discardableResult
    func getEntity(context: NSManagedObjectContext) -> HabitBlockEntity {
        let entity = HabitBlockEntity(context: context)
        entity.identifier = identifier
        entity.title = title
        entity.streak = Int64(streak)
        entity.lastDay = lastDay
        
        return entity
    }
}

class HabitBlocksStore: ObservableObject {
    
    @Published var habits = [HabitBlock]()
    
    init() {
        for entity in DataGateway.shared.getHabitBlockEntities() {
            habits.append(HabitBlock(fromEntity: entity))
        }
    }
    
    func addHabitBlock(with title: String) {
        let habitBlock = HabitBlock(title: title)
        
        habits.append(habitBlock)
        DataGateway.shared.saveHabitBlock(habitBlock: habitBlock)
    }
    
    func removeHabitBlock(habitBlock: HabitBlock) {
        for i in 0 ..< habits.count {
            if habitBlock.identifier == habits[i].identifier {
                habits.remove(at: i)
                break
            }
        }
        
        DataGateway.shared.deleteHabitBlock(habitBlock: habitBlock)
    }
}
