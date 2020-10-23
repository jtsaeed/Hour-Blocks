//
//  NewToDoListView.swift
//  Hour Blocks
//
//  Created by James Saeed on 05/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

/// The root view of the To Do List tab
struct ToDoListView: View {
    
    let refreshPublisher = NotificationCenter.default.publisher(for: NSNotification.Name("RefreshToDoList"))
    
    @StateObject var viewModel = ToDoListViewModel()
    
    var body: some View {
        VStack {
            HeaderView(title: "To Do List", subtitle: "\(viewModel.toDoItems.count) Items") {
                IconButton(iconName: "plus",
                           iconWeight: .bold,
                           action: viewModel.presentAddToDoItemView)
                    .sheet(isPresented: $viewModel.isAddToDoItemViewPresented) {
                        AddToDoItemView(viewModel: viewModel)
                    }
                
                IconButton(iconName: "clock",
                           iconWeight: .bold,
                           action: viewModel.presentToDoListHistoryView)
                    .sheet(isPresented: $viewModel.isToDoListHistoryPresented) {
                        ToDoListHistoryView(isPresented: $viewModel.isToDoListHistoryPresented )
                    }
            }
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    if let tip = viewModel.currentTip {
                        TipCardView(for: tip, onDismiss: viewModel.dismissTip)
                        NeonDivider().padding(.horizontal, 32)
                    }
                    
                    ForEach(viewModel.toDoItems) { toDoItemViewModel in
                        ToDoItemView(viewModel: toDoItemViewModel,
                                     onItemCleared: { viewModel.clear(toDoItem: toDoItemViewModel.toDoItem) },
                                     onItemCompleted: { viewModel.markAsCompleted(toDoItem: toDoItemViewModel.toDoItem)})
                    }
                }.padding(.top, 8)
                .padding(.bottom, 24)
            }
        }.navigationBarHidden(true)
        .onAppear(perform: viewModel.loadToDoItems)
        .onReceive(refreshPublisher) { _ in viewModel.loadToDoItems() }
    }
}

struct ToDoListView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListView(viewModel: ToDoListViewModel())
    }
}
