//
//  ToDoItemCardView.swift
//  Hour Blocks
//
//  Created by James Saeed on 12/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

/// A Card based view for displaying a To Do item.
struct ToDoItemView: View {
    
    @ObservedObject private var viewModel: ToDoItemViewModel
    
    private let onItemCleared: () -> Void
    private let onItemCompleted: () -> Void
    
    /// Creates an instance of ToDoItemView.
    ///
    /// - Parameters:
    ///   - viewModel: The corresponding view model for the given To Do item.
    ///   - onBlockCleared: The callback function to be triggered when the user chooses to clear the corresponding To Do item.
    ///   - onBlockCompleted: The callback function to be triggered when the user chooses to complete the corresponding To Do item.
    init(viewModel: ToDoItemViewModel, onItemCleared: @escaping () -> Void, onItemCompleted: @escaping ()-> Void) {
        self.viewModel = viewModel
        self.onItemCleared = onItemCleared
        self.onItemCompleted = onItemCompleted
    }
    
    var body: some View {
        Card {
            CardLabels(title: viewModel.getTitle(),
                       subtitle: viewModel.urgency,
                       subtitleColor: Color(viewModel.urgency.urgencyToColorString()),
                       subtitleOpacity: viewModel.toDoItem.urgency == .whenever ? 0.4 : 1.0,
                       horizontalAlignment: .center)
        }.padding(.horizontal, 24)
        
        .contextMenu(ContextMenu(menuItems: {
            Button(action: onItemCompleted) {
                Label("Complete", systemImage: "checkmark")
            }
            Divider()
            Button(action: viewModel.presentEditItemView) {
                Label("Edit", systemImage: "pencil")
            }
            Button(action: viewModel.presentAddToScheduleView) {
                Label("Add to Today", systemImage: "calendar.badge.plus")
            }
            Divider()
            Button(action: onItemCleared) {
                Label("Clear", systemImage: "trash")
            }
        }))
        
        .sheet(isPresented: $viewModel.isSheetPresented) {
            if viewModel.selectedSheet == .edit {
                EditToDoItemView(viewModel: viewModel)
            }
            
            if viewModel.selectedSheet == .addToSchedule {
                SchedulePickerView(isPresented: $viewModel.isSheetPresented,
                                   navigationTitle: "Add to Today",
                                   hourBlock: HourBlock(day: Date(), hour: 12, title: viewModel.toDoItem.title))
            }
        }
    }
}

struct ToDoItemView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoItemView(viewModel: ToDoItemViewModel(for: ToDoItem(title: "Test", urgency: .whenever)),
                     onItemCleared: {}, onItemCompleted: {})
    }
}
