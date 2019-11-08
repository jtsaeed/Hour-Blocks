//
//  ToDoView.swift
//  neon3
//
//  Created by James Saeed on 19/06/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import SwiftUI

struct ToDoListView: View {
    
    @EnvironmentObject var blocks: HourBlocksStore
    @ObservedObject var store = ToDoItemsStore()
    
    @State var isAddToBlockPresented = false
    
    var body: some View {
        List {
            Section(header: ToDoHeader(addButtonDisabled: store.toDoItems.isEmpty, items: store.toDoItems.count, toDoItemAdded: { title, priority in self.store.addToDoItem(with: title, priority) })) {
                if (store.toDoItems.isEmpty) {
                    EmptyToDoCard { title, priority in
                        self.store.addToDoItem(with: title, priority)
                    }
                } else {
                    ForEach(store.toDoItems.sorted().reversed(), id: \.self) { toDoItem in
                        ToDoCard(currentToDoItem: toDoItem)
                            .contextMenu {
                                Button(action: {
                                    self.isAddToBlockPresented.toggle()
                                }) {
                                    Text("Add to Block")
                                    Image(systemName: "plus")
                                }
                                .sheet(isPresented: self.$isAddToBlockPresented, content: {
                                    AddToBlockSheet(isPresented: self.$isAddToBlockPresented, title: toDoItem.title, didAddToBlock: { title, hour, minute in self.blocks.setTodayBlock(for: hour, minute, with: title) }).environmentObject(self.blocks)
                                })
                                Button(action: {
                                    // TODO: Edit
                                }) {
                                    Text("Edit")
                                    Image(systemName: "pencil")
                                }
                                Button(action: {
                                    self.store.removeToDoItem(toDo: toDoItem)
                                }) {
                                    Text("Clear")
                                    Image(systemName: "trash")
                                }
                            }
                        
                    }
                }
            }
        }
    }
}

struct ToDoCard: View {
    
    let currentToDoItem: ToDoItem
    
    var body: some View {
        ZStack {
            Card()
            ToDoCardLabels(title: currentToDoItem.title, priority: currentToDoItem.priority)
                .padding(EdgeInsets(top: 18, leading: 22, bottom: 18, trailing: 24))
        }.padding(EdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8))
    }
}

struct ToDoCardLabels: View {
    
    let title: String
    let priority: ToDoPriority
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            Text(priority.rawValue.uppercased())
                .font(.system(size: 14, weight: .semibold, design: .default))
                .foregroundColor(Color(priority.rawValue))
            Text(title.smartCapitalization())
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(Color("title"))
                .lineLimit(1)
        }
    }
}

#if DEBUG
struct ToDoView_Previews : PreviewProvider {
    static var previews: some View {
        ToDoListView()
    }
}
#endif
