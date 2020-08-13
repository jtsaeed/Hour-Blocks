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
    
    let date = Date(year: 2020, month: 08, day: 02, hour: 13, minute: 0)
    
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
        dataGateway.save(hourBlock: HourBlock(day: date, hour: 13, title: "Lunch"))
        dataGateway.save(hourBlock: HourBlock(day: date, hour: 15, title: "Gym"))
        dataGateway.save(hourBlock: HourBlock(day: date, hour: 16, title: "Work"))
        
        viewModel.currentDate = date
        viewModel.loadHourBlocks()
        
        let expectation = XCTestExpectation(description: "Load Hour Blocks from view model")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            
            XCTAssertEqual(self.viewModel.todaysHourBlocks[15].title, "Gym")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testAddHourBlock() {
        viewModel.addBlock(HourBlock(day: Date(), hour: 14, title: "Walk"))
        
        let expectation = XCTestExpectation(description: "Add Hour Block to view model")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(self.viewModel.todaysHourBlocks[14].title, "Walk")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testClearHourBlock() {
        let block = HourBlock(day: Date(), hour: 13, title: "Lunch")
        
        dataGateway.save(hourBlock: block)
        viewModel.clearBlock(block)
        
        let expectation = XCTestExpectation(description: "Clear Hour Block from view model")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(self.viewModel.todaysHourBlocks[14].title, "Empty")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testEnableFilter() {
        let expectation = XCTestExpectation(description: "Enable Hour Blocks filter from view model")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertTrue(self.viewModel.isFilterEnabled)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testDisableFilter() {
        viewModel.toggleFilter()
        
        let expectation = XCTestExpectation(description: "Disable Hour Blocks filter from view model")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertFalse(self.viewModel.isFilterEnabled)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
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
