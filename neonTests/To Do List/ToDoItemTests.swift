//
//  ToDoItemTests.swift
//  Hour BlocksTests
//
//  Created by James Saeed on 12/08/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import XCTest
import CoreData
@testable import Hour_Blocks

class ToDoItemTests: XCTestCase {
    
    var dataGateway: DataGateway!
    var viewModel: ToDoItemViewModel!

    override func setUpWithError() throws {
        dataGateway = DataGateway(for: mockPersistantContainer.viewContext)
        
        let toDoItem = ToDoItem(title: "Book meeting room", urgency: .soon)
        dataGateway.save(toDoItem: toDoItem)
        
        viewModel = ToDoItemViewModel(for: toDoItem)
    }

    override func tearDownWithError() throws {
        dataGateway.deleteAllToDoItems()
    }

    func testPresentEditItemView() {
        // TODO
    }
    
    func testDismissEditItemView() {
        // TODO
    }
    
    func testPresentAddToScheduleView() {
        // TODO
    }
    
    func testSaveTitleChanges() {
        // TODO
    }
    
    func testSavePriorityChanges() {
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
