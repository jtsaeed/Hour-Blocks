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
    
    let viewModel = ScheduleViewModel(dataGateway: TestDataGateway())

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
    
    var hourBlocks = [HourBlock]()
    
    mutating func getHourBlocks(for day: Date) -> [HourBlock] {
        hourBlocks = [
            HourBlock(day: day, hour: 6, title: "wake up"),
            HourBlock(day: day, hour: 7, title: "morning routine"),
            HourBlock(day: day, hour: 8, title: "have breakfast"),
            HourBlock(day: day, hour: 12, title: "have lunch"),
            HourBlock(day: day, hour: 1, title: "lecture"),
            HourBlock(day: day, hour: 3, title: "go to the gym"),
            HourBlock(day: day, hour: 4, title: "basketball game")
        ]
        
        return hourBlocks
    }
    
    mutating func saveHourBlock(block: HourBlock) {
        hourBlocks.append(block)
    }
    
    mutating func editHourBlock(block: HourBlock, set value: Any?, forKey key: String) {
        if let index = hourBlocks.firstIndex(where: { $0.id == block.id }) {
            if key == "iconOverride" {
                hourBlocks[index].iconOverride = value as? String
            } else if key == "title" {
                hourBlocks[index].title = value as? String
            } else if key == "hasReminder" {
                hourBlocks[index].hasReminder = value as! Bool
            }
        }
    }
    
    mutating func deleteHourBlock(block: HourBlock) {
        hourBlocks.removeAll(where: { $0.id == block.id })
    }
    
    func getToDoItems() -> [ToDoItem] { return [ToDoItem]() }
    func saveToDo(toDo: ToDoItem) { }
    func editToDo(toDo: ToDoItem, set value: Any?, forKey key: String) { }
    func deleteToDo(toDo: ToDoItem) { }
}
