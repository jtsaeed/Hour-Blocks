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
    
    init() {
        for hour in 0...24 {
            todaysBlocks.append(HourBlock(day: Date(), hour: hour, minute: .oclock, title: nil))
            todaysBlocks.append(HourBlock(day: Date(), hour: hour, minute: .fifteen, title: nil))
            todaysBlocks.append(HourBlock(day: Date(), hour: hour, minute: .halfPast, title: nil))
            todaysBlocks.append(HourBlock(day: Date(), hour: hour, minute: .fourtyFive, title: nil))
        }
        
        for entity in DataGateway.shared.getHourBlockEntities() {
            let block = HourBlock(fromEntity: entity)
            todaysBlocks[(block.hour * 4) + block.minute.rawValue] = block
        }
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
        futureBlocks.append(HourBlock(day: date, hour: hour, minute: minute, title: title))
    }
}
