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
    }
    
    func testLoadToDoItems() {
        dataGateway.save(toDoItem: ToDoItem(title: "Clean", urgency: ToDoUrgency.urgent))
        dataGateway.save(toDoItem: ToDoItem(title: "Eat", urgency: ToDoUrgency.whenever))
        
        viewModel.loadToDoItems()
        
        let expectation = XCTestExpectation(description: "view model's toDoItems array size is equal to the amount of toDoItems added")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(self.viewModel.toDoItems.count, 2)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testSortToDoItems() {
        dataGateway.save(toDoItem: ToDoItem(title: "Sleep", urgency: ToDoUrgency.whenever))
        dataGateway.save(toDoItem: ToDoItem(title: "Eat", urgency: ToDoUrgency.soon))
        dataGateway.save(toDoItem: ToDoItem(title: "Clean", urgency: ToDoUrgency.urgent))
        dataGateway.save(toDoItem: ToDoItem(title: "Run", urgency: ToDoUrgency.whenever))
        dataGateway.save(toDoItem: ToDoItem(title: "Code", urgency: ToDoUrgency.soon))
        
        viewModel.loadToDoItems()
        
        let expectation = XCTestExpectation(description: "The view model's toDoItems are correctly ordered by priority after loading")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(self.viewModel.toDoItems, self.viewModel.toDoItems.sorted())
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    
    func testAddToDoItem() {
        viewModel.add(toDoItem: ToDoItem(title: "Clean", urgency: ToDoUrgency.urgent))
        
        let expectation = XCTestExpectation(description: "The view model's toDoItems count is equal to 1 after calling viewModel.add")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(self.viewModel.toDoItems.count, 1)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testClearToDoItem() {
        let item1 = ToDoItem(title: "Clean", urgency: ToDoUrgency.urgent)
        let item2 = ToDoItem(title: "Eat", urgency: ToDoUrgency.whenever)
        
        dataGateway.save(toDoItem: item1)
        dataGateway.save(toDoItem: item2)
        
        viewModel.loadToDoItems()
        
        viewModel.clear(toDoItem: item1)
        
        let expectation = XCTestExpectation(description: "After calling ViewModel.clear there should be n-1 items in toDoItems")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(self.viewModel.toDoItems.count, 1)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testCompletedToDoItem() {
        let item1 = ToDoItem(title: "Clean", urgency: ToDoUrgency.urgent)
        let item2 = ToDoItem(title: "Eat", urgency: ToDoUrgency.whenever)
        
        dataGateway.save(toDoItem: item1)
        dataGateway.save(toDoItem: item2)
        
        viewModel.loadToDoItems()
        viewModel.markAsCompleted(toDoItem: item1)
        
        let expectation = XCTestExpectation(description: "After calling ViewModel.markAsComplete there should be n-1 items in toDoItems.")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(self.viewModel.toDoItems.count, 1)
            
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
