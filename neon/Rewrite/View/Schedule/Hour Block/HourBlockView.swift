//
//  HourBlockView.swift
//  neon6
//
//  Created by James Saeed on 27/06/2020.
//

import SwiftUI

struct HourBlockView: View {
    
    @ObservedObject var viewModel: HourBlockViewModel
    
    let onBlockCleared: () -> Void
    
    var body: some View {
        NewCard {
            VStack(spacing: 20) {
                HStack {
                    NewCardLabels(title: viewModel.title.smartCapitalization(),
                               subtitle: viewModel.time)
                    Spacer()
                    HourBlockIcon(name: viewModel.getIconName())
                }
                
                if !viewModel.subBlocks.isEmpty {
                    NeonDivider()
                    
                    VStack(spacing: 12) {
                        ForEach(viewModel.subBlocks) { subBlock in
                            SubBlockView(subBlock: subBlock)
                        }
                    }
                }
            }
        }.padding(.horizontal, 24)
        
        .contextMenu(
            ContextMenu(menuItems: {
                Button(action: viewModel.presentEditBlockView) {
                    Label("Edit", systemImage: "pencil")
                }
                .sheet(isPresented: $viewModel.isEditHourBlockViewPresented) {
                    EditHourBlockView(viewModel: viewModel)
                }
                
                Button(action: viewModel.presentManageSubBlocksView) {
                    Label("Sub Blocks", systemImage: "rectangle.grid.1x2")
                }
                .sheet(isPresented: $viewModel.isManageSubBlocksViewPresented) {
                    ManageSubBlocksView(isPresented: $viewModel.isManageSubBlocksViewPresented,
                                        viewModel: viewModel,
                                        hourBlock: viewModel.hourBlock,
                                        onSubBlockAdded: { _ in })
                }
                
                Button(action: clearBlock) {
                    Label("Clear", systemImage: "trash")
                }
            })
        )
    }
    
    func clearBlock() {
        viewModel.clearBlock()
        self.onBlockCleared()
    }
}

private struct SubBlockView: View {
    
    let subBlock: SubBlock
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .foregroundColor(Color("AccentColorLight"))
                    .frame(width: 16, height: 16)
                Circle()
                    .foregroundColor(Color("AccentColor"))
                    .frame(width: 8, height: 8)
            }
            
            Text(subBlock.title)
                .font(.system(size: 20, weight: .medium, design: .rounded))
                .opacity(0.85)
            
            Spacer()
        }
    }
}

struct NoHourBlocksView: View {
    
    var body: some View {
        NewCard {
            HStack {
                NewCardLabels(title: "Hour Blocks",
                           subtitle: "No",
                           titleColor: Color("subtitle"),
                           alignment: .center)
            }
        }.padding(.horizontal, 24)
    }
}
