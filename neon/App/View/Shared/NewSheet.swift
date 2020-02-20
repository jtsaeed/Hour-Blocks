//
//  NewBlockView.swift
//  neon3
//
//  Created by James Saeed on 23/06/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import SwiftUI
import StoreKit

struct NoSuggestionsCard: View {
    
    var body: some View {
        Card {
            HStack {
                CardLabels(title: "None",
                           subtitle: "Currently",
                           titleColor: Color("subtitle"),
                           alignment: .center)
            }
        }
    }
}

// MARK: New To Do

struct NewToDoView: View {
    
    @Binding var isPresented: Bool
    
    @ObservedObject var viewModel: ToDoListViewModel
    
    @State var title = ""
    @State var urgency: ToDoUrgency = .whenever
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                NeonTextField(title: $title, didReturn: { })
                Text("Urgency")
                    .font(.system(size: 28, weight: .semibold, design: .default))
                    .padding(.leading, 24)
                Picker("", selection: $urgency) {
                    Text("Whenever").tag(ToDoUrgency.whenever)
                    Text("Soon").tag(ToDoUrgency.soon)
                    Text("Urgent").tag(ToDoUrgency.urgent)
                }.pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal, 24)
                Spacer()
            }
            .navigationBarTitle("Add a new to do")
            .navigationBarItems(leading: Button(action: dismiss, label: {
                Text("Cancel")
            }), trailing: Button(action: addToDo, label: {
                Text("Add")
            }))
        }.accentColor(Color("primary"))
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func addToDo() {
        if title.isEmpty {
            HapticsGateway.shared.triggerErrorHaptic()
        } else {
            HapticsGateway.shared.triggerAddBlockHaptic()
            viewModel.addToDoItem(with: title, urgency)
            
            dismiss()
        }
    }
    
    func dismiss() {
        isPresented = false
    }
}
