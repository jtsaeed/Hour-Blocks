//
//  ToDoListHistoryView.swift
//  Hour Blocks
//
//  Created by James Litchfield on 23/10/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

/// The view of the To Do List History.
struct ToDoListHistoryView: View {
    
    @Binding var isPresented: Bool
    @StateObject var viewModel = ToDoListHistoryViewModel()
    
    var body: some View {
        NavigationView{
            CardsListView {
                ForEach(viewModel.completedToDoItems) { completedToDoItemViewModel in
                    CompletedToDoItemView(viewModel: completedToDoItemViewModel)
                }
            }.navigationTitle(AppStrings.ToDoList.historyHeader)
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(AppStrings.Global.done, action: dismiss)
                }
            }
        }.accentColor(Color(AppStrings.Colors.accent))
        .onReceive(AppPublishers.refreshToDoListPublisher) { _ in viewModel.loadCompletedToDoItems() }
    }
    
    /// Dismisses the current view.
    func dismiss() {
        isPresented = false
    }
    
    struct ToDoListHistoryView_Previews: PreviewProvider {
        static var previews: some View {
            ToDoListHistoryView(isPresented: .constant(true))
        }
    }
}
