//
//  NewToDoListView.swift
//  Hour Blocks
//
//  Created by James Saeed on 05/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct NewToDoListView: View {
    
    @StateObject var viewModel = NewToDoListViewModel()
    
    var body: some View {
        VStack {
            NewHeaderView(title: "To Do List", subtitle: "\(viewModel.toDoItems.count) Items") {
                NewIconButton(iconName: "plus",
                              iconWeight: .bold,
                              action: viewModel.presentAddToDoItemView)
            }.sheet(isPresented: $viewModel.isAddToDoItemViewPresented) {
                NewAddToDoItemView(viewModel: viewModel)
            }
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    ForEach(viewModel.toDoItems) { toDoItem in
                        ToDoItemCardView(toDoItem: toDoItem)
                    }
                }.padding(.top, 8)
                .padding(.bottom, 24)
            }
        }
    }
}

struct NewToDoListView_Previews: PreviewProvider {
    static var previews: some View {
        NewToDoListView(viewModel: NewToDoListViewModel())
    }
}
