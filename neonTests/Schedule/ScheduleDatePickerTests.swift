//
//  ScheduleDatePickerTests.swift
//  Hour BlocksTests
//
//  Created by James Saeed on 12/08/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import XCTest
import CoreData
@testable import Hour_Blocks

class ScheduleDatePickerTests: XCTestCase {
    
    let date = Date(year: 2020, month: 08, day: 02, hour: 13, minute: 0)
    
    var dataGateway: DataGateway!
    var viewModel: ScheduleDatePickerViewModel!

    override func setUpWithError() throws {
        dataGateway = DataGateway(for: mockPersistantContainer.viewContext)
        viewModel = ScheduleDatePickerViewModel(dataGateway: dataGateway,
                                                calendarGateway: MockCalendarGateway(),
                                                initialSelectedDate: date)
    }

    override func tearDownWithError() throws {
        dataGateway.deleteAllHourBlocks()
    }

    func testLoadHourBlocks() {
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
