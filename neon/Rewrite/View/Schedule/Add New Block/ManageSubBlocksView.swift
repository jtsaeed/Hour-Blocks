//
//  AddNewSubBlockView.swift
//  Hour Blocks
//
//  Created by James Saeed on 02/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct ManageSubBlocksView: View {
    
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: HourBlockViewModel
    
    let hourBlock: NewHourBlock
    let onSubBlockAdded: (SubBlock) -> Void
    
    @State var title = ""
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack(spacing: 16) {
                    NewNeonTextField(input: $title,
                                     didReturn: addSubBlock)
                    NewIconButton(iconName: "plus",
                                  iconWeight: .bold,
                                  action: addSubBlock)
                }.padding(24)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        ForEach(viewModel.subBlocks) { subBlock in
                            SubBlockCardView(subBlockTitle: subBlock.title,
                                             hourBlockTitle: viewModel.title,
                                             onSubBlockCleared: { viewModel.clearSubBlock(subBlock) })
                        }
                    }.padding(.top, 8)
                }
            }.navigationTitle("Sub Blocks")
            .navigationBarItems(trailing: Button("Done", action: dismiss))
        }
        .accentColor(Color("AccentColor"))
    }
    
    func addSubBlock() {
        viewModel.addSubBlock(SubBlock(of: hourBlock, title: title))
        
        dismiss()
    }
    
    func dismiss() {
        isPresented = false
    }
}

private struct SubBlockCardView: View {
    
    let subBlockTitle: String
    let hourBlockTitle: String

    let onSubBlockCleared: () -> Void
    
    var body: some View {
        NewCard {
            HStack {
                NewCardLabels(title: subBlockTitle.smartCapitalization(),
                              subtitle: hourBlockTitle.uppercased())
                Spacer()
                NewIconButton(iconName: "xmark",
                              iconWeight: .bold,
                              action: onSubBlockCleared)
            }
        }.padding(.horizontal, 24)
    }
}
