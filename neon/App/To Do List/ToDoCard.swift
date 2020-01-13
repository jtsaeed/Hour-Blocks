//
//  ToDoCard.swift
//  neon
//
//  Created by James Saeed on 26/11/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import SwiftUI

struct ToDoCard: View {
    
    let currentToDoItem: ToDoItem
    
    var body: some View {
        Card {
            CardLabels(title: self.currentToDoItem.title,
                       subtitle: self.currentToDoItem.priority.rawValue,
                       subtitleColor: Color(self.currentToDoItem.priority.rawValue),
                       alignment: .center)
        }.contextMenu { ToDoContextMenu(currentToDoItem: currentToDoItem) }
    }
}

struct ToDoContextMenu: View {
    
    @EnvironmentObject var blocksStore: ScheduleViewModel
    @EnvironmentObject var toDoItemsStore: ToDoItemsStore
    
    let currentToDoItem: ToDoItem
    
    @State var isRenamePresented = false
    @State var isAddToBlockPresented = false
    
    var body: some View {
        VStack {
            Button(action: {
                self.addToBlock()
            }) {
                Text("Add to Block")
                Image(systemName: "plus")
            }
            .sheet(isPresented: self.$isAddToBlockPresented, content: {
                AddToBlockSheet(isPresented: self.$isAddToBlockPresented, title: self.currentToDoItem.title)
                    .environmentObject(self.blocksStore)
            })
            /*
            Button(action: {
                self.edit()
            }) {
                Text("Edit")
                Image(systemName: "pencil")
            }
            .sheet(isPresented: self.$isRenamePresented, content: {
                NewToDoItemView(isPresented: self.$isRenamePresented, title: self.$toDoItemsStore.currentTitle, priority: self.$toDoItemsStore.currentPriority)
                    .environmentObject(self.toDoItemsStore)
            })
            */
            Button(action: {
                self.clear()
            }) {
                Text("Clear")
                Image(systemName: "trash")
            }
        }
    }
    
    func addToBlock() {
        isAddToBlockPresented.toggle()
    }
    
    func edit() {
        toDoItemsStore.currentTitle = currentToDoItem.title
        toDoItemsStore.currentPriority = currentToDoItem.priority
        isRenamePresented.toggle()
    }
    
    func clear() {
        toDoItemsStore.removeToDoItem(toDo: currentToDoItem)
    }
}

struct EmptyToDoCard: View {
    
    @EnvironmentObject var store: ToDoItemsStore
    
    @State var title = ""
    @State var priority: ToDoPriority = .none
    
    @State var isPresented = false
    
    var body: some View {
        EmptyListCard()
            .onTapGesture {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                self.isPresented.toggle()
            }
            .sheet(isPresented: $isPresented, content: {
                NewToDoItemView(isPresented: self.$isPresented, title: self.$title, priority: self.$priority)
                    .environmentObject(self.store)
            })
    }
}
