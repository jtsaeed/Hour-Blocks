//
//  ToDoListHistoryTest.swift
//  Hour BlocksTests
//
//  Created by James Litchfield on 23/10/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import XCTest
import CoreData
@testable import Hour_Blocks

class ToDoListHistorTests: XCTestCase {
    
    var dataGateway: DataGateway!
    var viewModel: ToDoListHistoryViewModel!
    
    override func setUpWithError() throws {
        dataGateway = DataGateway(for: mockPersistantContainer.viewContext)
        viewModel = ToDoListHistoryViewModel(dataGateway: dataGateway)
    }
    
    override func tearDownWithError() throws {
    }
    
    func testLoadCompletedToDoItems() {
        let item1 = ToDoItem(title: "Clean", urgency: ToDoUrgency.urgent)
        let item2 = ToDoItem(title: "Eat", urgency: ToDoUrgency.whenever)
        
        dataGateway.save(toDoItem: item1)
        dataGateway.save(toDoItem: item2)
        dataGateway.edit(toDoItem: item1, set: true, forKey: "completed")
        dataGateway.edit(toDoItem: item2, set: Date(), forKey: "completionDate")
        
        viewModel.loadCompletedToDoItems()
        
        let expectation = XCTestExpectation(description: "view model's completedToDoItems array size is equal to the amount of toDoItems that have been completed")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(self.viewModel.completedToDoItems.count, 1)
            
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
