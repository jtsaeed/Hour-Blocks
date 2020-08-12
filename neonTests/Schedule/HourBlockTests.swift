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
    
    var dataGateway: DataGateway!
    var viewModel: HourBlockViewModel!

    override func setUpWithError() throws {
        dataGateway = DataGateway(for: mockPersistantContainer.viewContext)
        
        let hourBlock = HourBlock(day: Date(), hour: 13, title: "Lunch")
        let subBlocks = [
            SubBlock(of: hourBlock, title: "Buy ingredients"),
            SubBlock(of: hourBlock, title: "Cook"),
            SubBlock(of: hourBlock, title: "Eat")
        ]
        
        dataGateway.save(hourBlock: hourBlock)
        for subBlock in subBlocks {
            dataGateway.save(subBlock: subBlock)
        }
        
        viewModel = HourBlockViewModel(for: hourBlock, and: subBlocks, dataGateway: dataGateway)
    }
    
    override func tearDownWithError() throws {
        dataGateway.deleteAllHourBlocks()
    }
    
    func testSaveTitleChanges() {
        // TODO
    }
    
    func testSaveIconChanges() {
        // TODO
    }
    
    func testAddSubBlock() {
        // TODO
    }
    
    func testClearSubBlock() {
        // TODO
    }
    
    func testGetFormattedTime() {
        // TODO
    }
    
    func testGetIconName() {
        // TODO
    }
    
    func testPresentAddHourBlockView() {
        
    }
    
    func testPresentEditBlockView() {
        
    }
    
    func testPresentManageSubBlocksView() {
        
    }
    
    func testPresentDuplicateBlockView() {
        
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
