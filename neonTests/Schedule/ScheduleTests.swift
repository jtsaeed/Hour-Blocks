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
    
    var dataGateway: DataGateway!
    var viewModel: ScheduleViewModel!

    override func setUpWithError() throws {
        dataGateway = DataGateway(for: mockPersistantContainer.viewContext)
        viewModel = ScheduleViewModel(dataGateway: dataGateway,
                                      calendarGateway: MockCalendarGateway(),
                                      analyticsGateway: MockAnalyticsGateway(),
                                      remindersGateway: MockRemindersGateway())
    }

    override func tearDownWithError() throws {
        dataGateway.deleteAllHourBlocks()
    }

    func testLoadHourBlocks() {
        dataGateway.save(hourBlock: HourBlock(day: Date(), hour: 13, title: "Lunch"))
        dataGateway.save(hourBlock: HourBlock(day: Date(), hour: 15, title: "Gym"))
        dataGateway.save(hourBlock: HourBlock(day: Date(), hour: 16, title: "Work"))
        
        viewModel.loadHourBlocks()
        
        let expectation = XCTestExpectation(description: "Load Hour Blocks from view model")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(self.viewModel.todaysHourBlocks[15].title, "Gym")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testAddHourBlock() {
        // TODO
    }
    
    func testClearHourBlock() {
        // TODO
    }
    
    func testEnableFilter() {
        // TODO
    }
    
    func testDisableFilter() {
        // TODO
    }

    func testPresentDatePickerView() {
        // TODO
    }
    
    func testDismissDatePickerView() {
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
