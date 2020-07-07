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
                    NewCardLabels(title: viewModel.title,
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
                Button(action: viewModel.presentManageSubBlocksView, label: {
                    Label("Add Sub Block", systemImage: "plus.square")
                })
                Button(action: clearBlock, label: {
                    Label("Clear", systemImage: "trash")
                })
            })
        )
        
        .sheet(isPresented: $viewModel.isManageSubBlocksViewPresented) {
            ManageSubBlocksView(isPresented: $viewModel.isManageSubBlocksViewPresented,
                                hourBlock: viewModel.hourBlock,
                                onSubBlockAdded: { viewModel.addSubBlock($0) })
        }
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
