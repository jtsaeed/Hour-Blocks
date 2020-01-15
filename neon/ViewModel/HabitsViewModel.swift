//
//  HabitBlockModel.swift
//  neon
//
//  Created by James Saeed on 12/01/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

class HabitsViewModel: ObservableObject {
    
    @Published var habits = [HabitBlock]()
    
    init() {
        refreshHabitBlocks()
    }
    
    func refreshHabitBlocks() {
        let loadedHabitBlocks = DataGateway.shared.getHabitBlockEntities().compactMap { habitBlockEntity in
            return HabitBlock(fromEntity: habitBlockEntity)
        }
        
        DispatchQueue.main.async { self.habits = loadedHabitBlocks }
    }
    
    func addHabitBlock(with title: String) {
        let habitBlock = HabitBlock(title: title)
        
        habits.append(habitBlock)
        DataGateway.shared.saveHabitBlock(habitBlock: habitBlock)
    }
    
    func removeHabitBlock(habitBlock: HabitBlock) {
        DispatchQueue.main.async { self.habits.removeAll(where: { $0.id == habitBlock.id }) }
        DataGateway.shared.deleteHabitBlock(habitBlock: habitBlock)
    }
    
    func completeHabitBlock(habitBlock: HabitBlock) {
        removeHabitBlock(habitBlock: habitBlock)
        
        var completedHabitBlock = habitBlock
        completedHabitBlock.complete()
        
        DispatchQueue.main.async { self.habits.append(completedHabitBlock) }
        DataGateway.shared.saveHabitBlock(habitBlock: completedHabitBlock)
    }
}
