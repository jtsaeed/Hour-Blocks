//
//  ToDoItem.swift
//  neon
//
//  Created by James Saeed on 13/05/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import Foundation

struct ToDoItem: Comparable {
	
	let title: String
	let priority: ToDoPriority
	
	static func < (lhs: ToDoItem, rhs: ToDoItem) -> Bool {
		if lhs.priority == .none && (rhs.priority == .low || rhs.priority == .medium || rhs.priority == .high) {
			return true
		} else if lhs.priority == .low && (rhs.priority == .medium || rhs.priority == .high) {
			return true
		} else if lhs.priority == .medium && rhs.priority == .high {
			return true
		} else {
			return false
		}
	}
}

enum ToDoPriority: String {
	
	case high = "HIGH PRIORITY"
	case medium = "MED PRIORITY"
	case low = "LOW PRIORITY"
	case none = "NO PRIORITY"
}
