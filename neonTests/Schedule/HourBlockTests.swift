//
//  HourBlockTests.swift
//  Hour BlocksTests
//
//  Created by James Saeed on 12/08/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import Foundation

import XCTest
import CoreData
@testable import Hour_Blocks

class HourBlockTests: XCTestCase {
    
    let date = Date(year: 2020, month: 08, day: 02, hour: 13, minute: 0)
    
    var dataGateway: DataGateway!
    var viewModel: HourBlockViewModel!
    
    override func setUpWithError() throws {
        dataGateway = DataGateway(for: mockPersistantContainer.viewContext)
        
        let hourBlock = HourBlock(day: date, hour: 13, title: "Lunch")
        let subBlocks = [
            SubBlock(of: hourBlock, title: "Buy ingredients"),
            SubBlock(of: hourBlock, title: "Cook"),
            SubBlock(of: hourBlock, title: "Eat")
        ]
        
        dataGateway.save(hourBlock: hourBlock)
        for subBlock in subBlocks {
            dataGateway.save(subBlock: subBlock)
        }
        
        viewModel = HourBlockViewModel(for: hourBlock,
                                       and: subBlocks,
                                       dataGateway: dataGateway,
                                       remindersGateway: MockRemindersGateway())
    }
    
    override func tearDownWithError() throws {
        dataGateway.deleteAllHourBlocks()
    }
    
    func testSaveTitleChanges() {
        let expectation = XCTestExpectation(description: "Save title changes title param in view model")
        
        viewModel.saveChanges(title: "Hello", icon: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(self.viewModel.getTitle(), "Hello")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testSaveIconChanges() {
        viewModel.saveChanges(title: viewModel.getTitle(), icon: .people)
        
        let expectation = XCTestExpectation(description: "Save icon changes icon param in view model")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(self.viewModel.hourBlock.icon, .people)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testAddSubBlock() {
        let initialSubBlockCount = viewModel.subBlocks.count
        viewModel.addSubBlock(SubBlock(of: viewModel.hourBlock, title: "food"))
        
        let expectation = XCTestExpectation(description: "Adding a subblock increases subblock array count in view model")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertGreaterThan(self.viewModel.subBlocks.count, initialSubBlockCount)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testClearSubBlock() {
        let initialSubBlockCount = viewModel.subBlocks.count
        viewModel.clearSubBlock(viewModel.subBlocks[0])
        
        let expectation = XCTestExpectation(description: "Clear a subblock decreases subblock array count in view model")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertLessThan(self.viewModel.subBlocks.count, initialSubBlockCount)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testGetFormattedTime() {
        let expectation = XCTestExpectation(description: "Gets the string 1PM from view model")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(self.viewModel.getFormattedTime(), "1PM" )
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testGetIconName() {
        let expectation = XCTestExpectation(description: "getIconName returns the string restaurant from view model")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(self.viewModel.hourBlock.icon.imageName, "restaurant")
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
