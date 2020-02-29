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
    
    var dataGateway: DataInterface
    
    @Published var currentHour = Calendar.current.component(.hour, from: Date())
    @Published var currentDate = Calendar.current.startOfDay(for: Date())
    
    @Published var currentHourBlocks = [HourBlock]()
    @Published var currentSubBlocks = [HourBlock]()
    
    @Published var currentSuggestions = [Suggestion]()
    
    @Published var currentTip: Tip?
    
    @Published var allDayEvent: ImportedCalendarEvent?
    
    init(dataGateway: DataInterface) {
        self.dataGateway = dataGateway
        
        loadHourBlocks()
    }
    
    func loadHourBlocks() {
        DispatchQueue.global(qos: .userInitiated).async {
            var temporaryHourBlocks = [HourBlock]()
            for hour in 0...23 {
                temporaryHourBlocks.append(HourBlock(day: self.currentDate, hour: hour, title: nil))
            }
            
            let loadedHourBlocks = DataGateway.shared.getHourBlocks(for: self.currentDate)
            for loadedHourBlock in loadedHourBlocks.filter({ $0.isSubBlock == false }) {
                temporaryHourBlocks[loadedHourBlock.hour] = loadedHourBlock
            }
            
            DispatchQueue.main.async { self.allDayEvent = nil }
            if CalendarGateway.shared.hasPermission() {
                for event in CalendarGateway.shared.importEvents(for: self.currentDate) {
                    if event.isAllDay { continue }
                    
                    for i in event.startingHour...event.endingHour {
                        var block = HourBlock(day: self.currentDate, hour: i, title: event.title)
                        block.domain = .calendar
                        block.calendarEvent = event.eventEntity
                        temporaryHourBlocks[i] = block
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.currentHourBlocks = temporaryHourBlocks
                self.currentSubBlocks = loadedHourBlocks.filter({ $0.isSubBlock })
            }
        }
    }
    
    func loadSuggestions(for hour: Int, on date: Date, parentDomain: BlockDomain?) {
        var suggestions = [Suggestion]()
        
        let popularString = NSLocalizedString("popular", comment: "")
        let frequentlyAddedString = NSLocalizedString("frequently added", comment: "")
        
        DispatchQueue.global(qos: .userInitiated).async {
            // frequently added
            let lastMonthsBlocks = DataGateway.shared.getLastMonthsHourBlocks(from: date, for: hour)
            let lastMonthsDomains = lastMonthsBlocks.compactMap({ $0.domain })
            var lastMonthsDomainFrequencies = [BlockDomain: Int]()
            
            for domain in lastMonthsDomains {
                lastMonthsDomainFrequencies[domain] = (lastMonthsDomainFrequencies[domain] ?? 0) + 1
            }
            
            suggestions = lastMonthsDomainFrequencies.compactMap({ key, value in
                guard value >= 3 else { return nil }
                return Suggestion(domain: key, reason: frequentlyAddedString, score: value + 10)
            })
            
            // weekday
            if date.weekday >= 2 && date.weekday <= 6 {
                if hour >= 9 && hour <= 17 {
                    if !suggestions.contains(where: { $0.domain == .work }) {
                        suggestions.append(Suggestion(domain: .work, reason: popularString, score: 6))
                    }
                    if !suggestions.contains(where: { $0.domain == .lecture }) {
                        suggestions.append(Suggestion(domain: .lecture, reason: popularString, score: 3))
                    }
                }
                
                if (hour == 8 || hour == 17) && !suggestions.contains(where: { $0.domain == .commute }) {
                    suggestions.append(Suggestion(domain: .commute, reason: popularString, score: 1))
                }
                
                if hour == 17 && !suggestions.contains(where: { $0.domain == .home }) {
                    suggestions.append(Suggestion(domain: .home, reason: popularString, score: 1))
                }
            }
            
            // weekend
            if (date.weekday == 6 || date.weekday == 7) && (hour >= 19 && hour <= 21) && !suggestions.contains(where: { $0.domain == .party })  {
                suggestions.append(Suggestion(domain: .party, reason: popularString, score: 1))
            }
            
            // every day, morning
            if hour >= 5 && hour <= 8 {
                if !suggestions.contains(where: { $0.domain == .wake }) {
                    suggestions.append(Suggestion(domain: .wake, reason: popularString, score: 2))
                }
                if !suggestions.contains(where: { $0.domain == .shower }) {
                    suggestions.append(Suggestion(domain: .shower, reason: popularString, score: 3))
                }
            }
            // every day, little after morning
            if hour >= 6 && hour <= 9 {
                if !suggestions.contains(where: { $0.domain == .coffee }) {
                    suggestions.append(Suggestion(domain: .coffee, reason: popularString, score: 1))
                }
                if !suggestions.contains(where: { $0.domain == .breakfast }) {
                    suggestions.append(Suggestion(domain: .breakfast, reason: popularString, score: 2))
                }
            }
            // every day, lunch
            if hour >= 11 && hour <= 14 && !suggestions.contains(where: { $0.domain == .lunch }) {
                suggestions.append(Suggestion(domain: .lunch, reason: popularString, score: 4))
            }
            // every day, dinner
            if hour >= 17 && hour <= 21 && !suggestions.contains(where: { $0.domain == .dinner }) {
                suggestions.append(Suggestion(domain: .dinner, reason: popularString, score: 4))
            }
            // every day, sleep
            if hour >= 21 && hour <= 23 && !suggestions.contains(where: { $0.domain == .sleep }) {
                suggestions.append(Suggestion(domain: .sleep, reason: popularString, score: 4))
            }
            
            suggestions = suggestions.filter({ $0.domain != parentDomain }).sorted(by: { $0.score > $1.score })
            if suggestions.count > 3 { suggestions = suggestions.dropLast(suggestions.count - 3) }
            
            DispatchQueue.main.async { self.currentSuggestions = suggestions }
        }
    }
    
    func add(hourBlock: HourBlock) {
        if hourBlock.isSubBlock {
            currentSubBlocks.append(hourBlock)
        } else {
            currentHourBlocks[hourBlock.hour] = hourBlock
        }
        
        DataGateway.shared.saveHourBlock(block: hourBlock)
        DataGateway.shared.incrementTotalBlockCount()
        AnalyticsGateway.shared.log(hourBlock: hourBlock)
        
        refreshTips()
    }
    
    private func refreshTips() {
        let totalBlockCount = DataGateway.shared.getTotalBlockCount()
        
        if totalBlockCount == 1 {
            currentTip = .blockOptions
        } else if totalBlockCount == 5 {
            currentTip = .swipeToChangeDay
        } else if totalBlockCount == 15 {
            currentTip = .viewSubBlocks
        }
    }
    
    func remove(hourBlock: HourBlock) {
        if hourBlock.isSubBlock {
            currentSubBlocks.removeAll(where: { $0.id == hourBlock.id })
            
            DataGateway.shared.deleteHourBlock(block: hourBlock)
        } else {
            if hourBlock.hasReminder {
                NotificationsGateway.shared.removeNotification(for: hourBlock)
            }
            
            currentHourBlocks[hourBlock.hour] = HourBlock(day: currentDate,
                                                          hour: hourBlock.hour,
                                                          title: nil)
            if hourBlock.domain == .calendar {
                CalendarGateway.shared.clear(event: hourBlock.calendarEvent!)
            } else {
                DataGateway.shared.deleteHourBlock(block: hourBlock)
            }
            
            for subBlock in currentSubBlocks.filter({ $0.hour == hourBlock.hour }) {
                DataGateway.shared.deleteHourBlock(block: subBlock)
            }
            
            currentSubBlocks.removeAll(where: { $0.hour == hourBlock.hour })
        }
        
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
                currentSubBlocks[index].domain = DomainsGateway.shared.determineDomain(for: newTitle)
                DataGateway.shared.editHourBlock(block: hourBlock, set: newTitle, forKey: "title")
            }
        } else {
            currentHourBlocks[hourBlock.hour].title = newTitle
            
            if hourBlock.domain == .calendar {
                CalendarGateway.shared.rename(event: currentHourBlocks[hourBlock.hour].calendarEvent!,
                                              to: newTitle)
            } else {
                currentHourBlocks[hourBlock.hour].domain = DomainsGateway.shared.determineDomain(for: newTitle)
                DataGateway.shared.editHourBlock(block: hourBlock, set: newTitle, forKey: "title")
            }
        }
    }
    
    func setReminder(_ status: Bool, for block: HourBlock) {
        for i in 0 ..< currentHourBlocks.count {
            if (block.id == currentHourBlocks[i].id) {
                currentHourBlocks[i].hasReminder = status
                DataGateway.shared.editHourBlock(block: currentHourBlocks[i], set: status, forKey: "hasReminder")
            }
        }
    }
    
    func previousDay() {
        let previousDay = currentDate - 1.days
        currentDate = Calendar.current.startOfDay(for: previousDay)
        currentHour = Calendar.current.isDateInToday(previousDay) ? Calendar.current.component(.hour, from: Date()) : DataGateway.shared.getDayStartTime()
        
        loadHourBlocks()
    }
    
    func nextDay() {
        let nextDay = currentDate + 1.days
        currentDate = Calendar.current.startOfDay(for: nextDay)
        currentHour = Calendar.current.isDateInToday(nextDay) ? Calendar.current.component(.hour, from: Date()) : DataGateway.shared.getDayStartTime()
        
        loadHourBlocks()
    }
}
