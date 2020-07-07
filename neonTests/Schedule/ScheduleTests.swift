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
        let dataGateway = NewDataGateway(for: mockPersistantContainer.viewContext)
        let viewModel = NewScheduleViewModel(dataGateway: dataGateway)
        
        dataGateway.saveHourBlock(block: NewHourBlock(day: Date(), hour: 13, title: "Lunch"))
        dataGateway.saveHourBlock(block: NewHourBlock(day: Date(), hour: 15, title: "Gym"))
        dataGateway.saveHourBlock(block: NewHourBlock(day: Date(), hour: 16, title: "Work"))
        
        measure { viewModel.loadHourBlocks() }
        
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
