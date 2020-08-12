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
        // TODO
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
