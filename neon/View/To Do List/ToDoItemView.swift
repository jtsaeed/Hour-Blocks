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
                       subtitleOpacity: 1.0,
                       alignment: .center)
        }.padding(.horizontal, 24)
        
        .contextMenu(ContextMenu(menuItems: {
            Button(action: {}) {
                Label("Edit", systemImage: "pencil")
            }
            Button(action: clearItem) {
                Label("Clear", systemImage: "trash")
            }
        }))
    }
    
    func clearItem() {
        viewModel.clearItem()
        self.onItemCleared()
    }
}

/*
struct ToDoItemCardView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoItemCardView()
    }
}
*/
