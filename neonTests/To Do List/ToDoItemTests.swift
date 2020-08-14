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
    
    func testSaveTitleChanges() {
        let expectation = XCTestExpectation(description: "The view model's title has changed after calling viewModel.saveChanges")
        
        
        viewModel.saveChanges(title: "new", urgency: .soon)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(self.viewModel.title, "new")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testSavePriorityChanges() {
        let expectation = XCTestExpectation(description: "view model's urgency is equal to ToDoPriority.urgent after calling viewModel.saveChanges")
        
        
        viewModel.saveChanges(title: viewModel.title, urgency: .urgent)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(self.viewModel.urgency, "urgent")
            
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
