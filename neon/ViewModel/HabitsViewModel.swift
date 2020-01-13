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
        DispatchQueue.main.async { self.habits.removeAll(where: { $0.identifier == habitBlock.identifier }) }
        DataGateway.shared.deleteHabitBlock(habitBlock: habitBlock)
    }
    
    func completeHabitBlock(habitBlock: HabitBlock) {
        print("The VM function was called")
        
        removeHabitBlock(habitBlock: habitBlock)
        
        var completedHabitBlock = habitBlock
        completedHabitBlock.complete()
        
        DispatchQueue.main.async { self.habits.append(completedHabitBlock) }
        DataGateway.shared.saveHabitBlock(habitBlock: completedHabitBlock)
    }
}
