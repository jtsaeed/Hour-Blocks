//
//  ScheduleViewModelTests.swift
//  neonTests
//
//  Created by James Saeed on 19/02/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import XCTest
@testable import neon

class ScheduleViewModelTests: XCTestCase {
    
    let viewModel = ScheduleViewModel(dataGateway: TestDataGateway.shared)

    override func setUp() {
        let date = Date(year: 2020, month: 2, day: 5, hour: 8, minute: 0)
        
        viewModel.currentDate = date
        viewModel.currentHour = date.hour
    }

    override func tearDown() { }

    func testLoadHourBlocks() {
        XCTAssert(viewModel.currentHourBlocks[12].domain == .lunch)
    }
}

struct TestDataGateway: DataInterface {
    
    static let shared = TestDataGateway()
    
    var hourBlockEntities = [HourBlockEntity]()
    
    mutating func getHourBlockEntities(for day: Date) -> [HourBlockEntity] {
        let hourBlock6 = HourBlock(day: day, hour: 6, title: "wake up").getInMemoryEntity()
        let hourBlock7 = HourBlock(day: day, hour: 7, title: "morning routine").getInMemoryEntity()
        let hourBlock8 = HourBlock(day: day, hour: 8, title: "have breakfast").getInMemoryEntity()
        let hourBlock12 = HourBlock(day: day, hour: 12, title: "have lunch").getInMemoryEntity()
        let hourBlock1 = HourBlock(day: day, hour: 1, title: "lecture").getInMemoryEntity()
        let hourBlock3 = HourBlock(day: day, hour: 3, title: "go to the gym").getInMemoryEntity()
        let hourBlock4 = HourBlock(day: day, hour: 4, title: "basketball game").getInMemoryEntity()
        
        hourBlockEntities = [hourBlock6, hourBlock7, hourBlock8, hourBlock12, hourBlock1, hourBlock3, hourBlock4]
        
        return hourBlockEntities
    }
    
    mutating func saveHourBlock(block: HourBlock) {
        hourBlockEntities.append(block.getInMemoryEntity())
    }
    
    mutating func editHourBlock(block: HourBlock, set value: Any?, forKey key: String) {
        if let index = hourBlockEntities.lastIndex(where: { $0.identifier == block.id }) {
            hourBlockEntities[index].setValue(value, forKey: key)
        }
    }
    
    mutating func deleteHourBlock(block: HourBlock) {
        hourBlockEntities.removeAll(where: { $0.identifier == block.id })
    }
    
    func getToDoEntities() -> [ToDoEntity] { return [ToDoEntity]() }
    func saveToDo(toDo: ToDoItem) { }
    func editToDo(toDo: ToDoItem, set value: Any?, forKey key: String) { }
    func deleteToDo(toDo: ToDoItem) { }
}
