//
//  HourBlock.swift
//  neon3
//
//  Created by James Saeed on 18/06/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import SwiftUI
import Combine
import CoreData

struct HourBlock: Hashable {
    
    let identifier: String
    let day: Date
    let hour: Int
    
    let title: String?
    var domain: BlockDomain?
    var hasReminder = false
    
    init(day: Date, hour: Int, title: String?) {
        self.identifier = UUID().uuidString
        self.day = day
        self.hour = hour
        
        self.title = title
        self.domain = DomainsGateway.shared.determineDomain(for: title)
    }
    
    init(fromEntity entity: HourBlockEntity) {
        self.identifier = entity.identifier!
        self.day = entity.day!
        self.hour = Int(entity.hour)
        
        self.title = entity.title
        self.domain = DomainsGateway.shared.determineDomain(for: title)
    }
    
    var formattedTime: String {
        if let format = DataGateway.shared.loadOtherSettings()[OtherSettingsKey.timeFormat.rawValue] {
            if format == 0 {
                return DataGateway.shared.isSystemClock12h() ? hour.get12hTime() : hour.get24hTime()
            } else if format == 1 {
                return hour.get12hTime()
            } else if format == 2 {
                return hour.get24hTime()
            }
        }
        
        return hour.get12hTime()
    }
    
    @discardableResult
    func getEntity(context: NSManagedObjectContext) -> HourBlockEntity {
        let entity = HourBlockEntity(context: context)
        entity.identifier = identifier
        entity.title = title
        entity.day = day
        entity.hour = Int64(hour)
        
        return entity
    }
}

class HourBlocksStore: ObservableObject {
    
    @Published var todaysBlocks = [HourBlock]()
    @Published var futureBlocks = [HourBlock]()
    @Published var subBlocks = [Int: [HourBlock]]()
    
    @Published var currentTitle = ""
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
                    loadedTodayBlocks[block.hour] = block
                } else if block.day < Date() {
                    DataGateway.shared.deleteHourBlock(block: block)
                }
            }
        
            DispatchQueue.main.async {
                self.todaysBlocks = loadedTodayBlocks
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
    
    func addSubBlock(for hour: Int, with title: String) {
        let block = HourBlock(day: Date(), hour: hour, title: title)
        
        if subBlocks[hour] == nil { subBlocks[hour] = [HourBlock]() }
        
        subBlocks[hour]?.append(block)
//        DataGateway.shared.save
    }
    
    func setTodayBlock(for hour: Int, with title: String) {
        let block = HourBlock(day: Date(), hour: hour, title: title)
        
        todaysBlocks[hour] = block
        DataGateway.shared.saveHourBlock(block: block)
        
        if let domainKey = block.domain?.key {
            DataGateway.shared.saveSuggestion(for: domainKey, at: block.hour)
        }
    }
    
    func removeTodayBlock(for hour: Int) {
        DataGateway.shared.deleteHourBlock(block: todaysBlocks[hour])
        todaysBlocks[hour] = HourBlock(day: Date(), hour: hour, title: nil)
    }
    
    func addFutureBlock(for date: Date, _ hour: Int, with title: String) {
        let block = HourBlock(day: date, hour: hour, title: title)
        
        futureBlocks.append(block)
        DataGateway.shared.saveHourBlock(block: block)
        
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
