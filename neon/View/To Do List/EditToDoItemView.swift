//
//  EditToDoItemView.swift
//  Hour Blocks
//
//  Created by James Saeed on 28/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

/// A view where a To Do item can be edited.
struct EditToDoItemView: View {
    
    @ObservedObject private var viewModel: ToDoItemViewModel
    
    @State private var title = ""
    @State private var urgency: ToDoUrgency = .whenever

    /// Creates an instance of EditToDoItemView.
    ///
    /// - Parameters:
    ///   - viewModel: The corresponding view model of the To Do item to be edited.
    init(viewModel: ToDoItemViewModel) {
        self.viewModel = viewModel
        self._title = State(initialValue: viewModel.toDoItem.title)
        self._urgency = State(initialValue: viewModel.toDoItem.urgency)
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                NeonTextField(text: $title)
                    .padding(24)
                
                Text(AppStrings.ToDoList.ToDoItem.urgency)
                    .font(.system(size: 28, weight: .bold, design: .default))
                    .padding(.leading, 24)
                Picker("", selection: $urgency) {
                    ForEach(ToDoUrgency.allCases, id: \.self) { toDoUrgency in
                        Text(toDoUrgency.rawValue.capitalized).tag(toDoUrgency)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 24)
                
                Spacer()
            }.navigationTitle(AppStrings.ToDoList.ToDoItem.editHeader)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(AppStrings.Global.cancel, action: viewModel.dismissEditItemView)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(AppStrings.Global.save, action: save)
                }
            }
        }.accentColor(Color(AppStrings.Colors.accent))
    }
    
    /// Performs the save changes request.
    private func save() {
        viewModel.saveChanges(newTitle: title, newUrgency: urgency)
    }
}

struct EditToDoItemView_Previews: PreviewProvider {
    static var previews: some View {
        EditToDoItemView(viewModel: ToDoItemViewModel(for: ToDoItem(title: "Test", urgency: .whenever)))
    }
}
