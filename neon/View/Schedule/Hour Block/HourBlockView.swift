//
//  HourBlockView.swift
//  neon6
//
//  Created by James Saeed on 27/06/2020.
//

import SwiftUI

/// A Card based view for displaying an Hour Block.
struct HourBlockView: View {
    
    @ObservedObject var viewModel: HourBlockViewModel
    
    private let onBlockCleared: () -> Void
    
    /// Creates an instance of HourBlockView.
    ///
    /// - Parameters:
    ///   - viewModel: The corresponding view model for the given Hour Block.
    ///   - onBlockCleared: The callback function to be triggered when the user chooses to clear the corresponding Hour Block.
    init(viewModel: HourBlockViewModel, onBlockCleared: @escaping () -> Void) {
        self.viewModel = viewModel
        self.onBlockCleared = onBlockCleared
    }
    
    var body: some View {
        Card {
            VStack(spacing: 20) {
                HStack {
                    CardLabels(title: viewModel.getTitle(),
                               subtitle: viewModel.getFormattedTime())
                    Spacer()
                    HourBlockIcon(viewModel.icon.imageName)
                }
                
                if !viewModel.subBlocks.isEmpty {
                    NeonDivider()
                    
                    VStack(spacing: 12) {
                        ForEach(viewModel.subBlocks) { subBlock in
                            SubBlockView(for: subBlock)
                        }
                    }
                }
            }
        }.padding(.horizontal, 24)

        .contextMenu(ContextMenu(menuItems: {
            Button(action: viewModel.presentEditBlockView) {
                Label(AppStrings.Schedule.HourBlock.menuEdit, systemImage: AppStrings.Icons.edit)
            }
            Button(action: viewModel.presentManageSubBlocksView) {
                Label(AppStrings.Schedule.HourBlock.menuSubBlocks, systemImage: AppStrings.Icons.subBlocks)
            }
            Divider()
            Button(action: viewModel.presentRescheduleBlockView) {
                Label(AppStrings.Schedule.HourBlock.menuReschedule, systemImage: AppStrings.Icons.reschedule)
            }
            Button(action: viewModel.presentDuplicateBlockView) {
                Label(AppStrings.Schedule.HourBlock.menuDuplicate, systemImage: AppStrings.Icons.copy)
            }
            Divider()
            Button(action: viewModel.presentClearBlockWarning) {
                Label(AppStrings.Global.clear, systemImage: AppStrings.Icons.clear)
            }
        }))
        
        .sheet(isPresented: $viewModel.isSheetPresented) {
            switch viewModel.selectedSheet {
            case .none:
                EmptyView()
            case .edit:
                EditHourBlockView(viewModel: viewModel)
            case .subBlocks:
                ManageSubBlocksView(viewModel: viewModel)
            case .reschedule:
                RescheduleBlockView(isPresented: $viewModel.isSheetPresented,
                                    hourBlock: viewModel.hourBlock)
            case .duplicate:
                SchedulePickerView(isPresented: $viewModel.isSheetPresented,
                                   navigationTitle: AppStrings.Schedule.HourBlock.duplicateHeader,
                                   hourBlock: viewModel.hourBlock,
                                   subBlocks: viewModel.subBlocks)
            }
        }
        
        .alert(isPresented: $viewModel.isClearBlockWarningPresented) {
            Alert(title: Text(AppStrings.Schedule.HourBlock.clearAlertTitle),
                  message: Text(AppStrings.Schedule.HourBlock.clearAlertText),
                  primaryButton: .destructive(Text(AppStrings.Global.clear), action: onBlockCleared),
                  secondaryButton: .cancel())
        }
    }
}

/// A Label-like view for displaying a Sub Block.
private struct SubBlockView: View {
    
    /// Environment variable identifying the current device colour scheme between dark or light mode.
    @Environment(\.colorScheme) var colorScheme
    
    private let subBlock: SubBlock
    
    /// Creates an instance of SubBlockView.
    ///
    /// - Parameters:
    ///   - subBlock: The Sub Block to be displayed.
    init(for subBlock: SubBlock) {
        self.subBlock = subBlock
    }
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .foregroundColor(Color(AppStrings.Colors.accent).getLightColor(darkMode: colorScheme == .dark))
                    .frame(width: 16, height: 16)
                Circle()
                    .foregroundColor(Color(AppStrings.Colors.accent))
                    .frame(width: 8, height: 8)
            }
            
            Text(subBlock.title)
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .opacity(0.85)
            
            Spacer()
        }
    }
}
