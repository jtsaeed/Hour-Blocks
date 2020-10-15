//
//  EditToDoItemView.swift
//  Hour Blocks
//
//  Created by James Saeed on 28/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct EditToDoItemView: View {
    
    @ObservedObject var viewModel: ToDoItemViewModel
    
    @State var title = ""
    @State var urgency: ToDoUrgency = .whenever
    
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
            }.navigationTitle("Edit To Do Item")
            .navigationBarItems(leading: Button("Cancel", action: viewModel.dismissEditItemView),
                                trailing: Button("Save", action: save))
        }
        .accentColor(Color("AccentColor"))
    }
    
    func save() {
        viewModel.saveChanges(title: title, urgency: urgency)
    }
}

struct EditToDoItemView_Previews: PreviewProvider {
    static var previews: some View {
        EditToDoItemView(viewModel: ToDoItemViewModel(for: ToDoItem(title: "Test", urgency: .whenever)))
    }
}
