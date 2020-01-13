//
//  HourBlocksViewModel.swift
//  neon
//
//  Created by James Saeed on 12/01/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

class ScheduleViewModel: ObservableObject {
    
    @Published var todaysBlocks = [HourBlock]()
    @Published var subBlocks = [Int: [HourBlock]]()
    @Published var currentTitle = ""
    
    @Published var futureBlocks = [HourBlock]()
    @Published var currentFutureTitle = ""
    @Published var currentFutureDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    
    @Published var allDayEvent = ""
    
    init() {
        reloadTodayBlocks()
        reloadFutureBlocks()
    }
    
    func reloadTodayBlocks() {
        DispatchQueue.global(qos: .userInteractive).async {
            var loadedTodayBlocks = [HourBlock]()
            var loadedSubBlocks = [Int: [HourBlock]]()
            
            for hour in 0...23 {
                loadedTodayBlocks.append(HourBlock(day: Date(), hour: hour, title: nil))
            }
            
            if CalendarGateway.shared.hasPermission() {
                for event in CalendarGateway.shared.importTodaysEvents() {
                    for i in event.startingHour...event.endingHour {
                        var block = HourBlock(day: Date(), hour: i, title: event.title)
                        block.domain = DomainsGateway.shared.domains["calendar"]
                        loadedTodayBlocks[i] = block
                    }
                }
            }
            
            for entity in DataGateway.shared.getHourBlockEntities() {
                let block = HourBlock(fromEntity: entity)
                
                if Calendar.current.isDateInToday(block.day) {
                    if block.isSubBlock {
                        
                        if loadedSubBlocks[block.hour] == nil { loadedSubBlocks[block.hour] = [HourBlock]() }
                        
                        loadedSubBlocks[block.hour]?.append(block)
                    } else {
                        loadedTodayBlocks[block.hour] = block
                    }
                } else if block.day < Date() {
                    DataGateway.shared.deleteHourBlock(block: block)
                }
            }
        
            DispatchQueue.main.async {
                self.todaysBlocks = loadedTodayBlocks
                self.subBlocks = loadedSubBlocks
                self.loadAllDayEvent()
            }
        }
    }
    
    private func loadAllDayEvent() {
        allDayEvent = CalendarGateway.shared.allDayEvent?.title ?? ""
    }
    
    func reloadFutureBlocks() {
        DispatchQueue.global(qos: .userInteractive).async {
            let calendarBlocks: [HourBlock] = CalendarGateway.shared.importFutureEvents().map { event in
                var block = HourBlock(day: event.startDate, hour: 0, title: event.title)
                block.domain = DomainsGateway.shared.domains["calendar"]
                
                return block
            }
            
            let storedBlocks: [HourBlock] = DataGateway.shared.getHourBlockEntities().map { entity in
                return HourBlock(fromEntity: entity)
            }.filter { block in !Calendar.current.isDateInToday(block.day) }
            
            DispatchQueue.main.async {
                self.futureBlocks = calendarBlocks + storedBlocks
            }
        }
    }
    
    func isSubBlocksEmpty(for hour: Int) -> Bool {
        if subBlocks[hour] == nil {
            return true
        } else {
            return subBlocks[hour]!.isEmpty
        }
    }
    
    func addSubBlock(for hour: Int, with title: String) {
        var block = HourBlock(day: Date(), hour: hour, title: title)
        block.isSubBlock = true
        
        if subBlocks[hour] == nil { subBlocks[hour] = [HourBlock]() }
        
        subBlocks[hour]?.append(block)
        DataGateway.shared.saveHourBlock(block: block)
    }
    
    func removeSubBlock(for block: HourBlock) {
        subBlocks[block.hour]?.removeAll(where: { $0.identifier == block.identifier })
        DataGateway.shared.deleteHourBlock(block: block)
    }
    
    func setTodayBlock(for hour: Int, with title: String) {
        let block = HourBlock(day: Date(), hour: hour, title: title)
        setTodayBlock(block)
        
        if let domainKey = block.domain?.key {
            DataGateway.shared.saveSuggestion(for: domainKey, at: block.hour)
        }
    }
    
    func setTodayBlock(_ block: HourBlock) {
        todaysBlocks[block.hour] = block
        DataGateway.shared.saveHourBlock(block: block)
        DataGateway.shared.incrementTotalBlockCount()
    }
    
    func removeTodayBlock(for hour: Int) {
        DataGateway.shared.deleteHourBlock(block: todaysBlocks[hour])
        todaysBlocks[hour] = HourBlock(day: Date(), hour: hour, title: nil)
        subBlocks[hour]?.removeAll()
    }
    
    func addFutureBlock(for date: Date, _ hour: Int, with title: String) {
        let block = HourBlock(day: date, hour: hour, title: title)
        
        futureBlocks.append(block)
        DataGateway.shared.saveHourBlock(block: block)
        DataGateway.shared.incrementTotalBlockCount()
        
        if let domainKey = block.domain?.key {
            DataGateway.shared.saveSuggestion(for: domainKey, at: block.hour)
        }
    }
    
    func removeFutureBlock(for block: HourBlock) {
        futureBlocks.removeAll { $0.identifier == block.identifier }
        DataGateway.shared.deleteHourBlock(block: block)
    }
    
    func setReminder(_ status: Bool, for block: HourBlock) {
        for i in 0 ..< todaysBlocks.count {
            if (block.identifier == todaysBlocks[i].identifier) {
                todaysBlocks[i].hasReminder = status
            }
        }
    }
}
