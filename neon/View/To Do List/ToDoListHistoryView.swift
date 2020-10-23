//
//  ToDoListHistoryView.swift
//  Hour Blocks
//
//  Created by James Litchfield on 23/10/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

/// The view of the To Do List History
struct ToDoListHistoryView: View {
    
    @Binding var isPresented: Bool
    @StateObject var viewModel = ToDoListHistoryViewModel()
    
    var body: some View {
        NavigationView{
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    ForEach(viewModel.completedToDoItems) { completedToDoItemViewModel in
                        CompletedToDoItemView(viewModel: completedToDoItemViewModel)
                    }
                }.padding(.top, 8)
                .padding(.bottom, 24)
            }
            .navigationTitle("History")
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
            
        }.accentColor(Color("AccentColor"))
    }
    
    func dismiss() { isPresented = false }
    
    struct ToDoListHistoryView_Previews: PreviewProvider {
        static var previews: some View {
            ToDoListHistoryView(isPresented: .constant(true))
        }
    }
}
