//
//  ToDoItemCardView.swift
//  Hour Blocks
//
//  Created by James Saeed on 12/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct ToDoItemView: View {
    
    @ObservedObject var viewModel: ToDoItemViewModel
    
    let onItemCleared: () -> Void
    
    var body: some View {
        Card {
            CardLabels(title: viewModel.getTitle(),
                       subtitle: viewModel.urgency,
                       subtitleColor: Color(viewModel.urgency.urgencyToColorString()),
                       subtitleOpacity: viewModel.toDoItem.urgency == .whenever ? 0.4 : 1.0,
                       alignment: .center)
        }.padding(.horizontal, 24)
        
        .contextMenu(ContextMenu(menuItems: {
            Button(action: viewModel.presentEditItemView) {
                Label("Edit", systemImage: "pencil")
            }
            Button(action: viewModel.presentAddToScheduleView) {
                Label("Add to Today", systemImage: "calendar.badge.plus")
            }
            Divider()
            Button(action: onItemCleared) {
                Label("Complete", systemImage: "checkmark")
            }
        }))
        
        .sheet(isPresented: $viewModel.isSheetPresented) {
            if viewModel.selectedSheet == .edit {
                EditToDoItemView(viewModel: viewModel)
            }
            
            if viewModel.selectedSheet == .addToSchedule {
                SchedulePickerView(isPresented: $viewModel.isSheetPresented,
                                   title: "Add to Today",
                                   hourBlock: HourBlock(day: Date(), hour: 12, title: viewModel.toDoItem.title))
            }
        }
    }
}

struct ToDoItemView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoItemView(viewModel: ToDoItemViewModel(for: ToDoItem(title: "Test", urgency: .whenever)),
                     onItemCleared: {})
    }
}
