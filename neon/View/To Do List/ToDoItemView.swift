//
//  ToDoItemCardView.swift
//  Hour Blocks
//
//  Created by James Saeed on 12/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct ToDoItemView: View {
    
    @ObservedObject var viewModel: ToDoItemViewModel
    
    let onItemCleared: () -> Void
    
    var body: some View {
        Card {
            CardLabels(title: viewModel.title,
                       subtitle: viewModel.urgency,
                       subtitleColor: Color(viewModel.urgency.urgencyToColorString()),
                       subtitleOpacity: viewModel.toDoItem.urgency == .whenever ? 0.4 : 1.0,
                       alignment: .center)
        }.padding(.horizontal, 24)
        
        .contextMenu(ContextMenu(menuItems: {
            Button(action: viewModel.presentEditItemView) {
                Label("Edit", systemImage: "pencil")
            }
            Button(action: onItemCleared) {
                Label("Clear", systemImage: "trash")
            }
        }))
        
        .sheet(isPresented: $viewModel.isEditItemViewPresented) {
            EditToDoItemView(viewModel: viewModel)
        }
    }
}

/*
struct ToDoItemCardView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoItemCardView()
    }
}
*/
