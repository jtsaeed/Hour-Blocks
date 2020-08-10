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
        Card {
            VStack(spacing: 20) {
                HStack {
                    CardLabels(title: viewModel.title.smartCapitalization(),
                               subtitle: viewModel.getFormattedTime())
                    Spacer()
                    HourBlockIcon(name: viewModel.selectedIcon == nil ? viewModel.getIconName() : viewModel.selectedIcon!.imageName)
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

        .contextMenu(ContextMenu(menuItems: {
            Button(action: viewModel.presentEditBlockView) {
                Label("Edit", systemImage: "pencil")
            }
            Button(action: viewModel.presentManageSubBlocksView) {
                Label("Sub Blocks", systemImage: "rectangle.grid.1x2")
            }
            Button(action: viewModel.presentDuplicateBlockView) {
                Label("Duplicate", systemImage: "plus.square.on.square")
            }
            Divider()
            Button(action: onBlockCleared) {
                Label("Clear", systemImage: "trash")
            }
        }))
        
        .sheet(isPresented: $viewModel.isSheetPresented) {
            if viewModel.selectedSheet == .edit {
                EditHourBlockView(viewModel: viewModel)
            }
            
            if viewModel.selectedSheet == .subBlocks {
                ManageSubBlocksView(isPresented: $viewModel.isSheetPresented,
                                    viewModel: viewModel,
                                    hourBlock: viewModel.hourBlock)
            }
            
            if viewModel.selectedSheet == .duplicate {
                SchedulePickerView(isPresented: $viewModel.isSheetPresented,
                                   title: "Duplicate Hour Block",
                                   hourBlock: viewModel.hourBlock)
            }
        }
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
        Card {
            HStack {
                CardLabels(title: "Hour Blocks",
                           subtitle: "No",
                           titleColor: Color("TextColor"),
                           alignment: .center)
            }
        }.padding(.horizontal, 24)
    }
}
