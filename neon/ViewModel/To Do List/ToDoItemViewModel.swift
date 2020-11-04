//
//  ToDoItemViewModel.swift
//  Hour Blocks
//
//  Created by James Saeed on 28/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI
import WidgetKit

/// The view model for the ToDoItemView.
class ToDoItemViewModel: ObservableObject, Identifiable {
    
    private let dataGateway: DataGateway
    
    private(set) var toDoItem: ToDoItem
    
    @AppStorage("autoCaps") private var autoCapsValue: Int = 0
    
    @Published private(set) var urgency: ToDoUrgency
    @Published var isClearToDoWarningPresented = false
    @Published var isSheetPresented = false
    @Published private(set) var selectedSheet: ToDoItemSheet?
    
    /// Creates an instance of the ToDoItemViewModel.
    ///
    /// - Parameters:
    ///   - toDoItem: The corresponding To Do item for the view model.
    ///   - dataGateway: The data gateway instance used to interface with Core Data. By default, this is set to an instance of DataGateway.
    init(for toDoItem: ToDoItem, dataGateway: DataGateway = DataGateway()) {
        self.dataGateway = dataGateway
        self.toDoItem = toDoItem
        self.urgency = toDoItem.urgency
    }
    
    /// Applies capitalisation to the To Do item title if need be, based on user preferences.
    ///
    /// - Returns:
    /// The formatted title of the view model's To Do item.
    func getTitle() -> String {
        return autoCapsValue == 0 ? toDoItem.title.smartCapitalization() : toDoItem.title
    }
}

// MARK: - Functionality

extension ToDoItemViewModel {
    
    /// Saves any title and urgency changes to the Core Data store and the view model.
    ///
    /// - Parameters:
    ///   - newTitle: The new title to be updated.
    ///   - newUrgency: The new urgency value to be updated.
    func saveChanges(newTitle: String, newUrgency: ToDoUrgency) {
        toDoItem.changeTitle(to: newTitle)
        urgency = newUrgency
        
        dataGateway.edit(toDoItem: toDoItem, set: newTitle, forKey: "title")
        dataGateway.edit(toDoItem: toDoItem, set: newUrgency.rawValue, forKey: "urgency")
        
        dismissEditItemView()
        
        NotificationCenter.default.post(name: Notification.Name("RefreshToDoList"), object: nil)
    }
    
    /// Marks a given To Do item as incompleted in the Core Data store and the view model.
    func markAsIncomplete() {
        HapticsGateway.shared.triggerClearBlockHaptic()
        
        dataGateway.edit(toDoItem: toDoItem, set: false, forKey: "completed")
        dataGateway.edit(toDoItem: toDoItem, set: nil, forKey: "completionDate")
        
        NotificationCenter.default.post(name: Notification.Name(AppPublishers.Names.refreshSchedule), object: nil)
        WidgetCenter.shared.reloadTimelines(ofKind: "ToDoWidget")
    }
    
    /// Presents the EditToDoItemView.
    func presentEditItemView() {
        isSheetPresented = true
        selectedSheet = .edit
    }
    
    /// Dismisses the EditToDoItemView.
    func dismissEditItemView() {
        isSheetPresented = false
        selectedSheet = .edit
    }
    
    /// Presents the SchedulePickerView.
    func presentAddToScheduleView() {
        isSheetPresented = true
        selectedSheet = .addToSchedule
    }
    
    /// Presents a warning alert for clearing the view model's corresponding ToDo block.
    func presentClearToDoWarning() {
        isClearToDoWarningPresented = true
    }
}

// MARK: - Comparable Conformity For Sorting

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
