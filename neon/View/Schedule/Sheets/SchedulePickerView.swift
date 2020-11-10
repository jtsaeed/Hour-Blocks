//
//  SchedulePickerSheet.swift
//  Hour Blocks
//
//  Created by James Saeed on 09/08/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

/// A view for adding an pre-determined block to the schedule.
struct SchedulePickerView: View {
    
    @ObservedObject private var viewModel: ScheduleViewModel
    
    @Binding private var isPresented: Bool
    
    private let navigationTitle: String
    private let hourBlock: HourBlock
    private let subBlocks: [SubBlock]?
    
    /// Creates an instance of SchedulePickerView.
    ///
    /// - Parameters:
    ///   - isPresented: A binding determining whether or not the view is presented.
    ///   - navigationTitle: The string to be used for the view's navigation title.
    ///   - hourBlock: The Hour Block to be added to the schedule within the picker.
    ///   - subBlocks: The array of Sub Blocks of the Hour Block to be added. By default, this is set to nil.
    init(isPresented: Binding<Bool>, navigationTitle: String, hourBlock: HourBlock, subBlocks: [SubBlock]? = nil) {
        self.viewModel = ScheduleViewModel(currentDate: hourBlock.day)
        self._isPresented = isPresented
        self.navigationTitle = navigationTitle
        self.hourBlock = hourBlock
        self.subBlocks = subBlocks
    }
    
    var body: some View {
        NavigationView {
            CardsListView {
                ForEach(viewModel.todaysHourBlocks.filter { $0.hourBlock.hour >= (viewModel.currentDate.isToday ?  viewModel.currentHour : UtilGateway.shared.dayStartHour()) }) { hourBlockViewModel in
                    if hourBlockViewModel.getTitle() != AppStrings.Schedule.HourBlock.empty {
                        CompactHourBlockView(viewModel: hourBlockViewModel)
                    } else {
                        PickerEmptyBlockView(viewModel: hourBlockViewModel,
                                             hourBlock: hourBlock,
                                             onNewBlockAdded: { add(hourBlock: $0) })
                    }
                }
            }.navigationTitle(navigationTitle)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(AppStrings.Global.save, action: dismiss)
                }
            }
        }.accentColor(Color(AppStrings.Colors.accent))
    }
    
    /// Adds an Hour Block to the schedule.
    ///
    /// - Parameters:
    ///   - hourBlock: The Hour Block to be added.
    private func add(hourBlock: HourBlock) {
        let updatedSubBlocks = subBlocks?.map { SubBlock(of: hourBlock, title: $0.title) }
        viewModel.addBlock(hourBlock, updatedSubBlocks)
    }
    
    /// Dismisses the current view after refreshing the schedule.
    private func dismiss() {
        NotificationCenter.default.post(name: Notification.Name(AppPublishers.Names.refreshSchedule), object: nil)
        isPresented = false
    }
}

/// A Card based view for displaying an empty Hour Block within the picker view.
private struct PickerEmptyBlockView: View {
    
    @ObservedObject var viewModel: HourBlockViewModel
    
    let hourBlock: HourBlock
    let onNewBlockAdded: (HourBlock) -> Void
    
    /// Creates an instance of PickerEmptyBlockView.
    ///
    /// - Parameters:
    ///   - viewModel: The view model for the empty Hour Block.
    ///   - hourBlock: The Hour Block to be added to the schedule within the picker.
    ///   - onNewBlockAdded: The callback function to be triggered when the user chooses to add the Hour Block.
    init(viewModel: HourBlockViewModel, hourBlock: HourBlock, onNewBlockAdded: @escaping (HourBlock) -> Void) {
        self.viewModel = viewModel
        self.hourBlock = hourBlock
        self.onNewBlockAdded = onNewBlockAdded
    }
    
    var body: some View {
        Card {
            HStack {
                CardLabels(title: AppStrings.Schedule.HourBlock.empty,
                           subtitle: viewModel.getFormattedTime(),
                           titleOpacity: 0.4)
                Spacer()
                IconButton(iconName: AppStrings.Icons.add,
                           iconWeight: .bold,
                           action: addNewHourBlock)
            }
        }.padding(.horizontal, 24)
    }
    
    /// Creates the new block by taking the original block's properties and replacing the day and hour with that of the empty block.
    private func addNewHourBlock() {
        let newHourBlock = HourBlock(day: viewModel.hourBlock.day,
                                     hour: viewModel.hourBlock.hour,
                                     title: hourBlock.title,
                                     icon: hourBlock.icon)
        
        onNewBlockAdded(newHourBlock)
    }
}

struct SchedulePickerView_Previews: PreviewProvider {
    static var previews: some View {
        SchedulePickerView(isPresented: .constant(true),
                           navigationTitle: "Picker",
                           hourBlock: HourBlock(day: Date(), hour: 17, title: "Dinner", icon: .food), subBlocks: nil)
    }
}
