//
//  HourBlockView.swift
//  neon6
//
//  Created by James Saeed on 27/06/2020.
//

import SwiftUI

/// A Card based view for displaying an Hour Block
struct HourBlockView: View {
    
    @ObservedObject var viewModel: HourBlockViewModel
    
    let onBlockCleared: () -> Void
    
    var body: some View {
        Card {
            VStack(spacing: 20) {
                HStack {
                    CardLabels(title: viewModel.getTitle(),
                               subtitle: viewModel.getFormattedTime())
                    Spacer()
                    HourBlockIcon(name: viewModel.icon.imageName)
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
            Divider()
            Button(action: viewModel.presentRescheduleBlockView) {
                Label("Reschedule", systemImage: "calendar.badge.clock")
            }
            Button(action: viewModel.presentDuplicateBlockView) {
                Label("Duplicate", systemImage: "plus.square.on.square")
            }
            Divider()
            Button(action: viewModel.presentClearBlockWarning) {
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
            
            if viewModel.selectedSheet == .reschedule {
                RescheduleBlockView(isPresented: $viewModel.isSheetPresented,
                                    hourBlock: viewModel.hourBlock)
            }
            
            if viewModel.selectedSheet == .duplicate {
                SchedulePickerView(isPresented: $viewModel.isSheetPresented,
                                   title: "Duplicate Hour Block",
                                   hourBlock: viewModel.hourBlock,
                                   subBlocks: viewModel.subBlocks)
            }
        }
        
        .alert(isPresented: $viewModel.isClearBlockWarningPresented) {
            Alert(title: Text("Clear Hour Block"),
                  message: Text("Are you sure you would like to clear this Hour Block? This will also clear any Sub Blocks within the Hour Block"),
                  primaryButton: .destructive(Text("Clear"), action: onBlockCleared),
                  secondaryButton: .cancel())
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
                .font(.system(size: 18, weight: .medium, design: .rounded))
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
                           horizontalAlignment: .center)
            }
        }.padding(.horizontal, 24)
    }
}
