//
//  AddNewSubBlockView.swift
//  Hour Blocks
//
//  Created by James Saeed on 02/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

/// A view for adding and removing Sub Blocks for a particular Hour Block.
struct ManageSubBlocksView: View {
    
    @ObservedObject var viewModel: HourBlockViewModel
    
    @State var title = ""
    
    /// Creates an instance of ManageSubBlocksView.
    ///
    /// - Parameters:
    ///   - viewModel: The corresponding view model of the Hour Block for which Sub Blocks are being managed.
    init(viewModel: HourBlockViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack(spacing: 16) {
                    NeonTextField(text: $title,
                                  onReturn: addSubBlock)
                    IconButton(iconName: AppStrings.Icons.add,
                               iconWeight: .bold,
                               action: addSubBlock)
                }.padding(24)
                
                CardsListView {
                    ForEach(viewModel.subBlocks) { subBlock in
                        SubBlockCardView(subBlockTitle: subBlock.title,
                                         hourBlockTitle: viewModel.hourBlock.title!,
                                         onSubBlockCleared: { viewModel.clearSubBlock(subBlock) })
                    }
                }
            }.navigationTitle(AppStrings.Schedule.HourBlock.subBlocksHeader)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(AppStrings.Global.done, action: viewModel.dismissManageSubBlocksView)
                }
            }
        }.accentColor(Color(AppStrings.Colors.accent))
    }
    
    func addSubBlock() {
        if !title.isEmpty {
            viewModel.addSubBlock(SubBlock(of: viewModel.hourBlock, title: title))
            title = ""
        } else {
            HapticsGateway.shared.triggerErrorHaptic()
        }
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
                IconButton(iconName: AppStrings.Icons.clear,
                           iconWeight: .medium,
                           iconColor: Color(AppStrings.Colors.urgent),
                           action: onSubBlockCleared)
            }
        }.padding(.horizontal, 24)
    }
}
