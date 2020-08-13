//
//  AddHourBlockTests.swift
//  Hour BlocksTests
//
//  Created by James Saeed on 12/08/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import XCTest
import CoreData
@testable import Hour_Blocks

class AddHourBlockTests: XCTestCase {
    
    let date = Date(year: 2020, month: 08, day: 02, hour: 19, minute: 0)
    let hour = 19
    
    var dataGateway: DataGateway!
    var viewModel: AddHourBlockViewModel!

    override func setUpWithError() throws {
        dataGateway = DataGateway(for: mockPersistantContainer.viewContext)
        viewModel = AddHourBlockViewModel(dataGateway: dataGateway, analyticsGateway: MockAnalyticsGateway())
    }

    override func tearDownWithError() throws {
        dataGateway.deleteAllHourBlocks()
    }

    func testLoadSuggestions() {
        viewModel.loadSuggestions(for: hour, on: date)
        
        let expectation = XCTestExpectation(description: "loadSuggestions returns array containing an element that has domain property equal to BlockDomain.relax")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            XCTAssertTrue(self.viewModel.currentSuggestions.contains(where: { $0.domain == .relax }))
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
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
