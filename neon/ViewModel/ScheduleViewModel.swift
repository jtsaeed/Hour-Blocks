//
//  NewScheduleViewModel.swift
//  neon
//
//  Created by James Saeed on 09/02/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import Foundation
import SwiftDate

class ScheduleViewModel: ObservableObject {
    
    @Published var currentDate = Calendar.current.startOfDay(for: Date())
    
    @Published var currentHourBlocks = [HourBlock]()
    @Published var currentSubBlocks = [HourBlock]()
    
    @Published var currentSuggestions = [Suggestion]()
    
    init() {
        loadHourBlocks()
    }
    
    func loadHourBlocks() {
        var temporaryHourBlocks = [HourBlock]()
        for hour in 0...23 {
            temporaryHourBlocks.append(HourBlock(day: currentDate, hour: hour, title: nil))
        }
        
        let loadedHourBlocks = DataGateway.shared.getHourBlockEntities(for: currentDate).compactMap({ HourBlock(fromEntity: $0) })
        for loadedHourBlock in loadedHourBlocks.filter({ $0.isSubBlock == false }) {
            temporaryHourBlocks[loadedHourBlock.hour] = loadedHourBlock
        }
        
        DispatchQueue.main.async {
            self.currentHourBlocks = temporaryHourBlocks
            self.currentSubBlocks = loadedHourBlocks.filter({ $0.isSubBlock })
        }
    }
    
    func loadSuggestions(for hour: Int, on date: Date) {
        var suggestions = [Suggestion]()
        
        // weekday
        if date.weekday >= 2 && date.weekday <= 6 {
            if hour >= 9 && hour <= 17 {
                suggestions.append(Suggestion(domain: .work, reason: "popular"))
                suggestions.append(Suggestion(domain: .lecture, reason: "popular"))
            }
            
            if hour == 8 || hour == 17 {
                suggestions.append(Suggestion(domain: .commute, reason: "popular"))
            }
        }
        
        // weekend
        if date.weekday == 6 || date.weekday == 7
        
        // every day
    }
    
    func add(hourBlock: HourBlock) {
        if hourBlock.isSubBlock {
            currentSubBlocks.append(hourBlock)
        } else {
            currentHourBlocks[hourBlock.hour] = hourBlock
        }
        
        DataGateway.shared.saveHourBlock(block: hourBlock)
//        AnalyticsGateway.shared.log(hourBlock: hourBlock, isSuggestion: false)
    }
    
    func remove(hourBlock: HourBlock) {
        if hourBlock.isSubBlock {
            currentSubBlocks.removeAll(where: { $0.id == hourBlock.id })
        } else {
            currentHourBlocks[hourBlock.hour] = HourBlock(day: currentDate,
                                                          hour: hourBlock.hour,
                                                          title: nil)
        }
        
        DataGateway.shared.deleteHourBlock(block: hourBlock)
    }
    
    func editBlockIcon(for hourBlock: HourBlock, iconOverride: String) {
        if hourBlock.isSubBlock {
            if let index = currentSubBlocks.firstIndex(where: { $0.id == hourBlock.id }) {
                currentSubBlocks[index].iconOverride = iconOverride
            }
        } else {
            currentHourBlocks[hourBlock.hour].iconOverride = iconOverride
        }
        
        DataGateway.shared.editHourBlock(block: hourBlock, set: iconOverride, forKey: "iconOverride")
    }
    
    func rename(hourBlock: HourBlock, with newTitle: String) {
        if hourBlock.isSubBlock {
            if let index = currentSubBlocks.firstIndex(where: { $0.id == hourBlock.id }) {
                currentSubBlocks[index].title = newTitle
            }
        } else {
            currentHourBlocks[hourBlock.hour].title = newTitle
        }
        
        DataGateway.shared.editHourBlock(block: hourBlock, set: newTitle, forKey: "title")
    }
}
