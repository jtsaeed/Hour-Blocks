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
    
    let hourBlock: HourBlock
    
    @State var title = ""
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack(spacing: 16) {
                    NeonTextField(text: $title,
                                  onReturn: addSubBlock)
                    IconButton(iconName: "plus",
                               iconWeight: .bold,
                               action: addSubBlock)
                }.padding(24)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        ForEach(viewModel.subBlocks) { subBlock in
                            SubBlockCardView(subBlockTitle: subBlock.title,
                                             hourBlockTitle: viewModel.hourBlock.title!,
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
        if !title.isEmpty {
            viewModel.addSubBlock(SubBlock(of: hourBlock, title: title))
            title = ""
        } else {
            HapticsGateway.shared.triggerErrorHaptic()
        }
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
        Card {
            HStack {
                CardLabels(title: subBlockTitle,
                           subtitle: hourBlockTitle.uppercased())
                Spacer()
                IconButton(iconName: "xmark",
                              iconWeight: .bold,
                              action: onSubBlockCleared)
            }
        }.padding(.horizontal, 24)
    }
}
