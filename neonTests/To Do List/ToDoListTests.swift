//
//  ToDoListTests.swift
//  Hour BlocksTests
//
//  Created by James Saeed on 12/08/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import XCTest
import CoreData
@testable import Hour_Blocks

class ToDoListTests: XCTestCase {
    
    var dataGateway: DataGateway!
    var viewModel: ToDoListViewModel!

    override func setUpWithError() throws {
        dataGateway = DataGateway(for: mockPersistantContainer.viewContext)
        viewModel = ToDoListViewModel(dataGateway: dataGateway, analyticsGateway: MockAnalyticsGateway())
    }

    override func tearDownWithError() throws {
        dataGateway.deleteAllToDoItems()
    }

    func testLoadToDoItems() {
        // TODO
    }
    
    func testAddToDoItem() {
        // TODO
    }
    
    func testClearToDoItem() {
        // TODO
    }
    
    func testPresentAddToDoItemView() {
        // TODO
    }
    
    func testDismissAddToDoItemView() {
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
