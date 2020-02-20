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
    
    let dataGateway: DataInterface
    
    @Published var currentHour = Calendar.current.component(.hour, from: Date())
    @Published var currentDate = Calendar.current.startOfDay(for: Date())
    
    @Published var currentHourBlocks = [HourBlock]()
    @Published var currentSubBlocks = [HourBlock]()
    
    @Published var currentSuggestions = [Suggestion]()
    
    @Published var allDayEvent: ImportedCalendarEvent?
    
    init(dataGateway: DataInterface) {
        self.dataGateway = dataGateway
        
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
        
        DispatchQueue.main.async { self.allDayEvent = nil }
        if CalendarGateway.shared.hasPermission() {
            for event in CalendarGateway.shared.importEvents(for: currentDate) {
                if event.isAllDay {
                    DispatchQueue.main.async { self.allDayEvent = event }
                    continue
                }
                
                for i in event.startingHour...event.endingHour {
                    var block = HourBlock(day: currentDate, hour: i, title: event.title)
                    block.domain = .calendar
                    temporaryHourBlocks[i] = block
                }
            }
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
            
            if hour == 17 {
                suggestions.append(Suggestion(domain: .home, reason: "popular"))
            }
        }
        
        // weekend
        if date.weekday == 6 || date.weekday == 7 {
            if hour >= 19 && hour <= 21 {
                suggestions.append(Suggestion(domain: .party, reason: "popular"))
            }
        }
        
        // every day, morning
        if hour >= 5 && hour <= 8 {
            suggestions.append(Suggestion(domain: .wake, reason: "popular"))
            suggestions.append(Suggestion(domain: .shower, reason: "popular"))
            suggestions.append(Suggestion(domain: .morning, reason: "popular"))
        }
        // every day, little after morning
        if hour >= 6 && hour <= 9 {
            suggestions.append(Suggestion(domain: .coffee, reason: "popular"))
            suggestions.append(Suggestion(domain: .breakfast, reason: "popular"))
        }
        // every day, lunch
        if hour >= 11 && hour <= 14 {
            suggestions.append(Suggestion(domain: .lunch, reason: "popular"))
        }
        // every day, dinner
        if hour >= 17 && hour <= 21 {
            suggestions.append(Suggestion(domain: .dinner, reason: "popular"))
        }
        // every day, sleep
        if hour >= 21 && hour <= 23 {
            suggestions.append(Suggestion(domain: .sleep, reason: "popular"))
        }
        
        DispatchQueue.main.async { self.currentSuggestions = suggestions }
    }
    
    func add(hourBlock: HourBlock) {
        if hourBlock.isSubBlock {
            currentSubBlocks.append(hourBlock)
        } else {
            currentHourBlocks[hourBlock.hour] = hourBlock
        }
        
        DataGateway.shared.saveHourBlock(block: hourBlock)
        AnalyticsGateway.shared.log(hourBlock: hourBlock)
    }
    
    func remove(hourBlock: HourBlock) {
        if hourBlock.isSubBlock {
            currentSubBlocks.removeAll(where: { $0.id == hourBlock.id })
        } else {
            if hourBlock.hasReminder {
                NotificationsGateway.shared.removeNotification(for: hourBlock)
            }
            
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
    
    func setReminder(_ status: Bool, for block: HourBlock) {
        for i in 0 ..< currentHourBlocks.count {
            if (block.id == currentHourBlocks[i].id) {
                currentHourBlocks[i].hasReminder = status
                print("HB: Set \(status)")
                DataGateway.shared.editHourBlock(block: currentHourBlocks[i], set: status, forKey: "hasReminder")
            }
        }
    }
}
