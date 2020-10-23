//
//  CompletedToDoItemView.swift
//  Hour Blocks
//
//  Created by James Litchfield on 23/10/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

/// A Card based view for displaying a Completed To Do Item.
struct CompletedToDoItemView: View {
    
    @ObservedObject private var viewModel: ToDoItemViewModel
    
    /// Creates an instance of ToDoItemView.
    ///
    /// - Parameters:
    ///   - viewModel: The corresponding view model for the given To Do item.
    init(viewModel: ToDoItemViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Card {
            CardLabels(title: viewModel.getTitle(),
                       subtitle: viewModel.toDoItem.completionDate?.getFormattedDate() ?? "N/A",
                       horizontalAlignment: .center)
        }.padding(.horizontal, 24)
    }
}
