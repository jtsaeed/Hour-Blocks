//
//  DataInterface.swift
//  neon
//
//  Created by James Saeed on 20/02/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import Foundation

protocol DataInterface {
    
    mutating func getHourBlocks(for day: Date) -> [HourBlock]
    mutating func saveHourBlock(block: HourBlock)
    mutating func editHourBlock(block: HourBlock, set value: Any?, forKey key: String)
    mutating func deleteHourBlock(block: HourBlock)
    
    mutating func getToDoItems() -> [ToDoItem]
    mutating func saveToDo(toDo: ToDoItem)
    mutating func editToDo(toDo: ToDoItem, set value: Any?, forKey key: String)
    mutating func deleteToDo(toDo: ToDoItem)
}
