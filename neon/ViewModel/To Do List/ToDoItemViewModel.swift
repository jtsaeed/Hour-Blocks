//
//  ToDoItemViewModel.swift
//  Hour Blocks
//
//  Created by James Saeed on 28/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

class ToDoItemViewModel: ObservableObject, Identifiable {
    
    private let dataGateway: DataGateway
    
    private(set) var toDoItem: ToDoItem
    
    @AppStorage("autoCaps") var autoCapsValue: Int = 0
    
    @Published var urgency: String
    
    @Published var isSheetPresented = false
    @Published var selectedSheet: ToDoItemSheet?
    
    init(for toDoItem: ToDoItem, dataGateway: DataGateway) {
        self.dataGateway = dataGateway
        
        self.toDoItem = toDoItem
        self.urgency = toDoItem.urgency.rawValue
    }
    
    convenience init(for toDoItem: ToDoItem) {
        self.init(for: toDoItem, dataGateway: DataGateway())
    }
    
    func presentEditItemView() {
        isSheetPresented = true
        selectedSheet = .edit
    }
    
    func dismissEditItemView() {
        isSheetPresented = false
        selectedSheet = .edit
    }
    
    func presentAddToScheduleView() {
        isSheetPresented = true
        selectedSheet = .addToSchedule
    }
    
    func saveChanges(title: String, urgency: ToDoUrgency) {
        toDoItem.changeTitle(to: title)
        self.urgency = urgency.rawValue
        
        dataGateway.edit(toDoItem: toDoItem, set: title, forKey: "title")
        dataGateway.edit(toDoItem: toDoItem, set: urgency.rawValue, forKey: "urgency")
        
        dismissEditItemView()
        
        NotificationCenter.default.post(name: Notification.Name("RefreshToDoList"), object: nil)
    }
    
    func getTitle() -> String {
        return autoCapsValue == 0 ? toDoItem.title.smartCapitalization() : toDoItem.title
    }
}

extension ToDoItemViewModel: Comparable {
    
    static func == (lhs: ToDoItemViewModel, rhs: ToDoItemViewModel) -> Bool {
        return lhs.urgency == rhs.urgency
    }
    
    static func < (lhs: ToDoItemViewModel, rhs: ToDoItemViewModel) -> Bool {
        if lhs.toDoItem.urgency == .whenever && (rhs.toDoItem.urgency == .soon || rhs.toDoItem.urgency == .urgent) {
            return false
        } else if lhs.toDoItem.urgency == .soon && rhs.toDoItem.urgency == .urgent {
            return false
        } else {
            return true
        }
    }
}

enum ToDoItemSheet {
    case edit, addToSchedule
}
