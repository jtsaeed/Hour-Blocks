//
//  NewAddToDoItemView.swift
//  Hour Blocks
//
//  Created by James Saeed on 19/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

/// A view where a To Do item can be added by a user inputted title.
struct AddToDoItemView: View {
    
    @ObservedObject private var viewModel: ToDoListViewModel
    
    @State private var title = ""
    @State private var urgency: ToDoUrgency = .whenever
    
    /// Creates an instance of AddToDoItemView.
    ///
    /// - Parameters:
    ///   - viewModel: The view model of the To Do List.
    init(viewModel: ToDoListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack(spacing: 16) {
                    NeonTextField(text: $title,
                                  onReturn: addToDoItem)
                    IconButton(iconName: "plus",
                               iconWeight: .bold,
                               action: addToDoItem)
                }.padding(24)
                
                Text("Urgency")
                    .font(.system(size: 28, weight: .bold, design: .default))
                    .padding(.leading, 24)
                Picker("", selection: $urgency) {
                    ForEach(ToDoUrgency.allCases, id: \.self) { toDoUrgency in
                        Text(toDoUrgency.rawValue.capitalized).tag(toDoUrgency)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal, 24)
                
                Spacer()
            }.navigationTitle("Add a To Do Item")
            .navigationBarItems(leading: Button("Cancel", action: dismiss))
        }
        .accentColor(Color("AccentColor"))
    }
    
    /// Adds a given To Do item after checking if the title is empty.
    private func addToDoItem() {
        if !title.isEmpty {
            viewModel.add(toDoItem: ToDoItem(title: title, urgency: urgency))
            dismiss()
        } else {
            HapticsGateway.shared.triggerErrorHaptic()
        }
    }
    
    /// Dismisses the current view.
    private func dismiss() {
        viewModel.dismissAddToDoItemView()
    }
}

struct AddToDoItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddToDoItemView(viewModel: ToDoListViewModel())
    }
}
