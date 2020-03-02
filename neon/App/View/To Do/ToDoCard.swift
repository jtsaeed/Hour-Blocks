//
//  ToDoCard.swift
//  neon
//
//  Created by James Saeed on 09/02/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct ToDoCard: View {
    
    @EnvironmentObject var scheduleViewModel: ScheduleViewModel
    @ObservedObject var viewModel: ToDoListViewModel
    
    @State var offset: CGFloat = 0
    @State var isSwiped = false
    
    @State var isSheetPresented = false
    @State var activeSheet = 0
    
    let toDoItem: ToDoItem
    
    var body: some View {
        SwipeableToDoCard(offset: $offset, swiped: $isSwiped, toDoItem: toDoItem) {
            HStack(spacing: 28) {
                SwipeOption(iconName: "plus.square",
                            primaryColor: Color("primary"),
                            secondaryColor: Color("primaryLight"),
                            action: self.addToBlock)
                SwipeOption(iconName: "pencil",
                            primaryColor: Color("primary"),
                            secondaryColor: Color("primaryLight"),
                            weight: .bold,
                            action: self.rename)
                SwipeOption(iconName: "checkmark",
                            primaryColor: Color("green"),
                            secondaryColor: Color("greenLight"),
                            action: self.complete)
            }
        }.contextMenu {
            if !isSwiped {
                Button(action: addToBlock) {
                    Text("Add to Block")
                    Image(systemName: "plus")
                }
                Button(action: rename) {
                    Text("Rename")
                    Image(systemName: "pencil")
                }
                if toDoItem.urgency != .urgent {
                    Button(action: { self.changeUrgency(to: .urgent) }) {
                        Text("Change to \(NSLocalizedString("urgent", comment: ""))")
                        Image(systemName: "timer")
                    }
                }
                if toDoItem.urgency != .soon {
                    Button(action: { self.changeUrgency(to: .soon) }) {
                        Text("Change to \(NSLocalizedString("soon", comment: ""))")
                        Image(systemName: "timer")
                    }
                }
                if toDoItem.urgency != .whenever {
                    Button(action: { self.changeUrgency(to: .whenever) }) {
                        Text("Change to \(NSLocalizedString("whenever", comment: ""))")
                        Image(systemName: "timer")
                    }
                }
                Button(action: complete) {
                    Text("Complete")
                    Image(systemName: "checkmark")
                }
            }
        }
        .sheet(isPresented: self.$isSheetPresented, content: {
            if self.activeSheet == 0 {
                AddToBlockSheet(isPresented: self.$isSheetPresented,
                                title: self.toDoItem.title)
                    .environmentObject(self.scheduleViewModel)
            } else if self.activeSheet == 1 {
                RenameToDoView(isPresented: self.$isSheetPresented,
                               viewModel: self.viewModel,
                               toDoItem: self.toDoItem)
            }
        })
    }
    
    func addToBlock() {
        HapticsGateway.shared.triggerLightImpact()
        isSheetPresented = true
        activeSheet = 0
        unSwipe()
    }
    
    func rename() {
        HapticsGateway.shared.triggerLightImpact()
        isSheetPresented = true
        activeSheet = 1
        unSwipe()
    }
    
    func changeUrgency(to urgency: ToDoUrgency) {
        viewModel.changeToDoItemUrgency(toDo: toDoItem, newUrgency: urgency)
        HapticsGateway.shared.triggerLightImpact()
    }
    
    func complete() {
        viewModel.removeToDoItem(toDo: toDoItem)
        HapticsGateway.shared.triggerCompletionHaptic()
    }
    
    func unSwipe() {
        isSwiped = false
        offset = 0
    }
}
