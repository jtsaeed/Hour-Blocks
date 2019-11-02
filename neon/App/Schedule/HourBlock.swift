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
    let minute: BlockMinute
    
    let title: String?
    let domain: BlockDomain?
    var hasReminder = false
    
    init(day: Date, hour: Int, minute: BlockMinute, title: String?) {
        self.identifier = UUID().uuidString
        self.day = day
        self.hour = hour
        self.minute = minute
        
        self.title = title
        self.domain = DomainsGateway.shared.determineDomain(for: title)
    }
    
    init(fromEntity entity: HourBlockEntity) {
        self.identifier = entity.identifier!
        self.day = entity.day!
        self.hour = Int(entity.hour)
        self.minute = BlockMinute(rawValue: Int(entity.minute))!
        
        self.title = entity.title
        self.domain = DomainsGateway.shared.determineDomain(for: title)
    }
    
    var formattedTime: String {
        if hour == 0 {
            return "12\(minute.rawValue.getFormattedMinute())AM"
        } else if hour < 12 {
            return "\(hour)\(minute.rawValue.getFormattedMinute())AM"
        } else if hour == 12 {
            return "\(hour)\(minute.rawValue.getFormattedMinute())PM"
        } else {
            return "\(hour - 12)\(minute.rawValue.getFormattedMinute())PM"
        }
    }
    
    @discardableResult
    func getEntity(context: NSManagedObjectContext) -> HourBlockEntity {
        let entity = HourBlockEntity(context: context)
        entity.identifier = identifier
        entity.title = title
        entity.day = day
        entity.hour = Int64(hour)
        entity.minute = Int64(minute.rawValue)
        
        return entity
    }
}

enum BlockMinute: Int {
    
    case oclock = 0
    case fifteen = 1
    case halfPast = 2
    case fourtyFive = 3
}

class HourBlocksStore: ObservableObject {
    
    @Published var todaysBlocks = [HourBlock]()
    @Published var futureBlocks = [HourBlock]()
    
    @Published var allDayEvent = ""
    
    init() {
        initialiseBlocks()
        loadCalenderBlocks()
        loadAllDayEvent()
        loadBlocks()
        loadFutureBlocks()
    }
    
    private func initialiseBlocks() {
        for hour in 0...24 {
            todaysBlocks.append(HourBlock(day: Date(), hour: hour, minute: .oclock, title: nil))
            todaysBlocks.append(HourBlock(day: Date(), hour: hour, minute: .fifteen, title: nil))
            todaysBlocks.append(HourBlock(day: Date(), hour: hour, minute: .halfPast, title: nil))
            todaysBlocks.append(HourBlock(day: Date(), hour: hour, minute: .fourtyFive, title: nil))
        }
    }
    
    private func loadCalenderBlocks() {
        if CalendarGateway.shared.hasPermission() {
            for event in CalendarGateway.shared.importTodaysEvents() {
                for i in event.startingHour...event.endingHour {
                    let block1 = HourBlock(day: Date(), hour: i, minute: .oclock, title: event.title)
                    todaysBlocks[(block1.hour * 4)] = block1
                    let block2 = HourBlock(day: Date(), hour: i, minute: .fifteen, title: event.title)
                    todaysBlocks[(block2.hour * 4) + 1] = block2
                    let block3 = HourBlock(day: Date(), hour: i, minute: .halfPast, title: event.title)
                    todaysBlocks[(block3.hour * 4) + 2] = block3
                    let block4 = HourBlock(day: Date(), hour: i, minute: .fourtyFive, title: event.title)
                    todaysBlocks[(block4.hour * 4) + 3] = block4
                }
            }
        }
    }
    
    private func loadAllDayEvent() {
        allDayEvent = CalendarGateway.shared.allDayEvent?.title ?? ""
    }
    
    private func loadBlocks() {
        for entity in DataGateway.shared.getHourBlockEntities() {
            if Calendar.current.isDateInToday(entity.day!) {
                let block = HourBlock(fromEntity: entity)
                todaysBlocks[(block.hour * 4) + block.minute.rawValue] = block
            }
        }
    }
    
    private func loadFutureBlocks() {
        
    }
    
    func setTodayBlock(for hour: Int, _ minute: BlockMinute, with title: String) {
        let block = HourBlock(day: Date(), hour: hour, minute: minute, title: title)
        
        todaysBlocks[(hour * 4) + minute.rawValue] = block
        DataGateway.shared.saveHourBlock(block: block)
    }
    
    func removeTodayBlock(for hour: Int, _ minute: BlockMinute = .oclock) {
        DataGateway.shared.deleteHourBlock(block: todaysBlocks[(hour * 4) + minute.rawValue])
        todaysBlocks[(hour * 4) + minute.rawValue] = HourBlock(day: Date(), hour: hour, minute: minute, title: nil)
    }
    
    func addFutureBlock(for date: Date, _ hour: Int, _ minute: BlockMinute = .oclock, with title: String) {
        let block = HourBlock(day: date, hour: hour, minute: minute, title: title)
        
        futureBlocks.append(block)
        DataGateway.shared.saveHourBlock(block: block)
    }
    
    func setReminder(_ status: Bool, for block: HourBlock) {
        for i in 0 ..< todaysBlocks.count {
            if (block.identifier == todaysBlocks[i].identifier) {
                todaysBlocks[i].hasReminder = status
            }
        }
    }
}