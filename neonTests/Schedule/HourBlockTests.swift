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
    
    override func tearDownWithError() throws { }
    
    func testSaveTitleChanges() {
        viewModel.saveChanges(newTitle: "Hello", newIcon: nil)
            
        XCTAssertEqual(self.viewModel.getTitle(), "Hello")
    }
    
    func testSaveIconChanges() {
        viewModel.saveChanges(newTitle: viewModel.getTitle(), newIcon: .people)
        
        XCTAssertEqual(self.viewModel.hourBlock.icon, .people)
    }
    
    func testAddSubBlock() {
        let initialSubBlockCount = viewModel.subBlocks.count
        viewModel.addSubBlock(SubBlock(of: viewModel.hourBlock, title: "food"))
        
        XCTAssertGreaterThan(self.viewModel.subBlocks.count, initialSubBlockCount)
    }
    
    func testClearSubBlock() {
        let initialSubBlockCount = viewModel.subBlocks.count
        viewModel.clearSubBlock(viewModel.subBlocks[0])
        
        XCTAssertLessThan(self.viewModel.subBlocks.count, initialSubBlockCount)
    }
    
    func testGetFormattedTime() {
        XCTAssertEqual(self.viewModel.getFormattedTime(), "1PM")
    }
    
    func testGetIconName() {
        XCTAssertEqual(self.viewModel.hourBlock.icon.imageName, "restaurant")
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
