//
//  NewToDoListView.swift
//  Hour Blocks
//
//  Created by James Saeed on 05/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct ToDoListView: View {
    
    @StateObject var viewModel = ToDoListViewModel()
    
    var body: some View {
        VStack {
            HeaderView(title: "To Do List", subtitle: "\(viewModel.toDoItems.count) Items") {
                IconButton(iconName: "plus",
                              iconWeight: .bold,
                              action: viewModel.presentAddToDoItemView)
            }.sheet(isPresented: $viewModel.isAddToDoItemViewPresented) {
                AddToDoItemView(viewModel: viewModel)
            }
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    ForEach(viewModel.toDoItems) { toDoItemViewModel in
                        ToDoItemView(viewModel: toDoItemViewModel,
                                     onItemCleared: { viewModel.clear(toDoItem: toDoItemViewModel.toDoItem) })
                    }
                }.padding(.top, 8)
                .padding(.bottom, 24)
            }
        }
    }
}

struct ToDoListView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListView(viewModel: ToDoListViewModel())
    }
}
