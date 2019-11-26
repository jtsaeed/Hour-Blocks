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
    @EnvironmentObject var store: ToDoItemsStore
    
    var body: some View {
        List {
            Section(header: ToDoHeader(addButtonDisabled: store.toDoItems.isEmpty, items: store.toDoItems.count)) {
                if store.toDoItems.isEmpty {
                    EmptyToDoCard()
                } else {
                    ForEach(store.toDoItems.sorted(), id: \.self) { toDoItem in
                        ToDoCard(currentToDoItem: toDoItem)
                    }
                }
            }
        }
    }
}
