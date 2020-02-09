//
//  ToDoListView.swift
//  neon
//
//  Created by James Saeed on 09/02/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct ToDoListView: View {
    
    @ObservedObject var viewModel = ToDoListViewModel()
    
    var body: some View {
        NavigationView {
            List {
                Section(header: ToDoListHeader(viewModel: viewModel)) {
                    ForEach(viewModel.toDoItems.sorted(by: { $0 < $1 })) { toDoItem in
                        ToDoCard(viewModel: self.viewModel, toDoItem: toDoItem)
                    }
                }
            }
            .navigationBarTitle("To Do List")
            .navigationBarHidden(true)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

private struct ToDoListHeader: View {
    
    @ObservedObject var viewModel: ToDoListViewModel
    
    @State var isPresented = false
    
    var body: some View {
        Header(title: "To Do List",
               subtitle: "\(viewModel.toDoItems.count) ITEM\(viewModel.toDoItems.count == 1 ? "" : "S")") {
            Button(action: self.add) {
                Image("add_button")
            }
            .padding(.top, 32)
            .padding(.trailing, 47)
            .sheet(isPresented: self.$isPresented, content: {
                NewToDoView(isPresented: self.$isPresented, viewModel: self.viewModel)
            })
        }
    }
    
    func add() {
        HapticsGateway.shared.triggerLightImpact()
        isPresented.toggle()
    }
}
