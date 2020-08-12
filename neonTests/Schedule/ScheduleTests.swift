//
//  ScheduleViewModelTests.swift
//  neonTests
//
//  Created by James Saeed on 19/02/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import XCTest
import CoreData
@testable import Hour_Blocks

class ScheduleTests: XCTestCase {

    override func setUpWithError() throws { }

    override func tearDownWithError() throws { }

    func testLoadHourBlocks() {
        let dataGateway = DataGateway(for: mockPersistantContainer.viewContext)
        let calendarGateway = CalendarGateway()
        let viewModel = ScheduleViewModel(dataGateway: dataGateway)
        
        dataGateway.save(hourBlock: HourBlock(day: Date(), hour: 13, title: "Lunch"))
        dataGateway.save(hourBlock: HourBlock(day: Date(), hour: 15, title: "Gym"))
        dataGateway.save(hourBlock: HourBlock(day: Date(), hour: 16, title: "Work"))
        
        let expectation = XCTestExpectation(description: "Load Hour Blocks from view model")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(viewModel.todaysHourBlocks[15].title, "Gym")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }

    func testPresentDatePickerView() {
        // TODO
    }
    
    func testCycleToNextDay() {
        // TODO
    }
    
    func testCycleToPreviousDay() {
        // TODO
    }
    
    func testReturnToToday() {
        // TODO
    }
    
    lazy var mockPersistantContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "neon")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false // Make it simpler in test env
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            // Check if the data store is in memory
            precondition( description.type == NSInMemoryStoreType )
                                        
            // Check if creating container wrong
            if let error = error {
                fatalError("Create an in-mem coordinator failed \(error)")
            }
        }
        return container
    }()
}
