//
//  ToDoCard.swift
//  neon
//
//  Created by James Saeed on 09/02/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct ToDoCard: View {
    
    @ObservedObject var viewModel: ToDoListViewModel
    
    let toDoItem: ToDoItem
    
    var body: some View {
        Card {
            CardLabels(title: self.toDoItem.title,
                       subtitle: self.toDoItem.urgency.rawValue.uppercased(),
                       subtitleColor: Color(self.toDoItem.urgency.rawValue.urgencyToColorString()),
                       alignment: .center)
        }.contextMenu {
            ToDoCardContextMenu(viewModel: viewModel, toDoItem: toDoItem)
        }
    }
}

struct ToDoCardContextMenu: View {
    
    @EnvironmentObject var scheduleViewModel: ScheduleViewModel
    @ObservedObject var viewModel: ToDoListViewModel
    
    let toDoItem: ToDoItem
    
    @State var isAddToBlockPresented = false
    @State var isRenamePresented = false
    
    var body: some View {
        VStack {
            Button(action: addToBlock) {
                Text("Add to Block")
                Image(systemName: "plus")
            }
            .sheet(isPresented: self.$isAddToBlockPresented, content: {
                AddToBlockSheet(isPresented: self.$isAddToBlockPresented, title: self.toDoItem.title)
                    .environmentObject(self.scheduleViewModel)
            })
            Button(action: rename) {
                Text("Rename")
                Image(systemName: "pencil")
            }
            .sheet(isPresented: self.$isRenamePresented, content: {
                RenameToDoView(isPresented: self.$isRenamePresented,
                               viewModel: self.viewModel,
                               toDoItem: self.toDoItem)
            })
            if toDoItem.urgency != .urgent {
                Button(action: { self.changeUrgency(to: .urgent) }) {
                    Text("Change to Urgent")
                    Image(systemName: "timer")
                }
            }
            if toDoItem.urgency != .soon {
                Button(action: { self.changeUrgency(to: .soon) }) {
                    Text("Change to Soon")
                    Image(systemName: "timer")
                }
            }
            if toDoItem.urgency != .whenever {
                Button(action: { self.changeUrgency(to: .whenever) }) {
                    Text("Change to Whenever")
                    Image(systemName: "timer")
                }
            }
            Button(action: complete) {
                Text("Complete")
                Image(systemName: "checkmark")
            }
        }
    }
    
    func addToBlock() {
        isAddToBlockPresented = true
    }
    
    func rename() {
        isRenamePresented = true
    }
    
    func changeUrgency(to urgency: ToDoUrgency) {
        viewModel.changeToDoItemUrgency(toDo: toDoItem, newUrgency: urgency)
        HapticsGateway.shared.triggerLightImpact()
    }
    
    func complete() {
        viewModel.removeToDoItem(toDo: toDoItem)
        HapticsGateway.shared.triggerCompletionHaptic()
    }
}
