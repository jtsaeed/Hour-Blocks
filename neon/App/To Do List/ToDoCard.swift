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
        ZStack {
            Card()
            CardLabels(title: currentToDoItem.title,
                       subtitle: currentToDoItem.priority.rawValue,
                       subtitleColor: Color(currentToDoItem.priority.rawValue),
                       alignment: .center)
            .modifier(CardContentPadding())
        }.modifier(CardPadding())
        .contextMenu { ToDoContextMenu(currentToDoItem: currentToDoItem) }
    }
}

struct ToDoContextMenu: View {
    
    @EnvironmentObject var blocksStore: HourBlocksStore
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
            
            Button(action: {
                self.edit()
            }) {
                Text("Edit")
                Image(systemName: "pencil")
            }
            .sheet(isPresented: self.$isRenamePresented, content: {
                NewToDoItemView(isPresented: self.$isRenamePresented, title: self.$toDoItemsStore.currentTitle, priority: self.$toDoItemsStore.currentPriority).environmentObject(self.toDoItemsStore)
            })
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
