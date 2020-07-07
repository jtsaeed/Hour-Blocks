//
//  NewToDoListView.swift
//  Hour Blocks
//
//  Created by James Saeed on 05/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct NewToDoListView: View {
    
    @ObservedObject var viewModel: NewToDoListViewModel
    
    var body: some View {
        VStack {
            NewHeaderView(title: "To Do List", subtitle: "\(viewModel.toDoItems.count) Items") {
                NewIconButton(iconName: "calendar", action: viewModel.addToDoItem)
            }
            
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 24) {
                    ForEach(viewModel.toDoItems) { toDo in
                        Text(toDo.title)
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
