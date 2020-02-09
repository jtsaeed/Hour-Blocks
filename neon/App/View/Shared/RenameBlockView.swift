//
//  RenameBlockSheet.swift
//  neon
//
//  Created by James Saeed on 18/01/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct RenameBlockView: View {
    
    @EnvironmentObject var viewModel: ScheduleViewModel
    
    @Binding var isPresented: Bool
    
    @State var title = ""
    
    let currentBlock: HourBlock
    let blockType: BlockType
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                NeonTextField(title: $title,
                              color: blockType == .sub ? Color("secondaryLight") : Color("primaryLight"),
                              didReturn: addBlock)
                Spacer()
            }
            .navigationBarTitle("Rename Block")
            .navigationBarItems(leading: Button(action: {
                self.isPresented = false
            }, label: {
                Text("Cancel")
            }), trailing: Button(action: addBlock, label: {
                Text("Confirm")
            }))
        }.accentColor(Color(blockType == .sub ? "secondary" : "primary"))
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            self.title = self.currentBlock.title!
        }
    }
    
    func addBlock() {
        if self.title.isEmpty {
            HapticsGateway.shared.triggerErrorHaptic()
        } else {
            HapticsGateway.shared.triggerLightImpact()
            viewModel.renameBlock(blockType, for: currentBlock, newTitle: title)
            isPresented = false
        }
    }
}

struct RenameToDoView: View {
    
    @Binding var isPresented: Bool
    
    @ObservedObject var viewModel: ToDoListViewModel
    
    @State var title = ""
    
    let toDoItem: ToDoItem
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                NeonTextField(title: $title,
                              color: Color("primaryLight"),
                              didReturn: renameToDo)
                Spacer()
            }
            .navigationBarTitle("Rename To Do")
            .navigationBarItems(leading: Button(action: {
                self.isPresented = false
            }, label: {
                Text("Cancel")
            }), trailing: Button(action: addBlock, label: {
                Text("Confirm")
            }))
        }.accentColor(Color("primary"))
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            self.title = self.toDoItem.title
        }
    }
    
    func renameToDo() {
        
    }
    
    func addBlock() {
        if self.title.isEmpty {
            HapticsGateway.shared.triggerErrorHaptic()
        } else {
            HapticsGateway.shared.triggerLightImpact()
            viewModel.renameToDoItem(toDo: toDoItem, newTitle: title)
            isPresented = false
        }
    }
}
