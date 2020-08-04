//
//  HourBlockViewModel.swift
//  Hour Blocks
//
//  Created by James Saeed on 01/06/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import XCTest
import CoreData
@testable import Hour_Blocks

class HourBlockTests: XCTestCase {
    
    override func setUpWithError() throws { }

    override func tearDownWithError() throws { }

    func testPresentAddHourBlockView() {
        // TODO
    }
    
    func testPresentRenameHourBlockView() {
        // TODO
    }
    
    func testPresentDuplicateHourBlockView() {
        // TODO
    }
    
    func testPresentIconPickerView() {
        // TODO
    }
    
    func testPresentManageSubBlocksView() {
        // TODO
    }
    
    func testSetReminder() {
        // TODO
    }
    
    func testClearReminder() {
        // TODO
    }
    
    func testClearBlock() {
        let dataGateway = NewDataGateway(for: mockPersistantContainer.viewContext)
        let scheduleViewModel = NewScheduleViewModel(dataGateway: dataGateway)
        let hourBlock = NewHourBlock(day: Date(), hour: 12, title: "Lunch")
        let viewModel = HourBlockViewModel(for: hourBlock)
        
        dataGateway.saveHourBlock(block: hourBlock)
        viewModel.clearBlock()
        scheduleViewModel.loadHourBlocks()
        
        let expectation = XCTestExpectation(description: "Load Hour Blocks from view model")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(scheduleViewModel.todaysHourBlocks[12].title, "Empty")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    lazy var mockPersistantContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "neon6")
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
