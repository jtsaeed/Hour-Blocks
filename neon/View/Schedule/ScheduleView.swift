//
//  NewScheduleView.swift
//  Hour Blocks
//
//  Created by James Saeed on 01/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI
import SwiftDate

/// The root view of the Schedule tab.
struct ScheduleView: View {
    
    @StateObject private var viewModel = ScheduleViewModel()
    
    var body: some View {
        VStack {
            HeaderView(title: AppStrings.Schedule.header, subtitle: viewModel.currentDate.getFormattedDate()) {
                HStack(spacing: 16) {
                    if !viewModel.currentDate.isToday {
                        IconButton(iconName: AppStrings.Icons.undo,
                                   iconWeight: .medium,
                                   action: viewModel.returnToToday)
                    }
                    IconButton(iconName: AppStrings.Icons.calendar,
                               action: viewModel.presentDatePickerView)
                }
            }
            .gesture(DragGesture(minimumDistance: 128, coordinateSpace: .local).onEnded { drag in
                if drag.translation.width > 0 {
                    viewModel.regressCurrentDay()
                } else {
                    viewModel.advanceCurentDay()
                }
            })
            .sheet(isPresented: $viewModel.isDatePickerViewPresented) {
                ScheduleDatePicker(isPresented: $viewModel.isDatePickerViewPresented,
                                   currentScheduleDate: $viewModel.currentDate,
                                   onDateChanged: viewModel.loadHourBlocks)
            }
            
            ScheduleBlocksListView(viewModel: viewModel)
        }.onAppear(perform: viewModel.handleCalendarPermissions)
        .onReceive(AppPublishers.refreshSchedulePublisher) { _ in viewModel.loadHourBlocks() }
        .onReceive(AppPublishers.refreshOnLaunchPublisher) { _ in viewModel.refreshCurrentDate() }
    }
}

private struct ScheduleBlocksListView: View {
    
    @ObservedObject var viewModel: ScheduleViewModel
    
    var body: some View {
        CardsListView {
            if let tip = viewModel.currentTip {
                TipCardView(for: tip, onDismiss: viewModel.dismissTip)
                NeonDivider().padding(.horizontal, 32)
            }
            
            ForEach(viewModel.todaysCalendarBlocks.filter { $0.endDate.toLocalTime().hour >= (viewModel.currentDate.isToday ? viewModel.currentHour : UtilGateway.shared.dayStartHour()) }) { event in
                CalendarBlockView(for: event)
            }
            
            if (viewModel.todaysCalendarBlocks.filter { $0.endDate.toLocalTime().hour >= (viewModel.currentDate.isToday ? viewModel.currentHour : UtilGateway.shared.dayStartHour()) }).count > 0 {
                NeonDivider().padding(.horizontal, 32)
            }
            
            ForEach(viewModel.todaysHourBlocks.filter { $0.hourBlock.hour >= (viewModel.currentDate.isToday ?  viewModel.currentHour : UtilGateway.shared.dayStartHour()) }) { hourBlockViewModel in
                if hourBlockViewModel.getTitle() != AppStrings.Schedule.HourBlock.empty {
                    HourBlockView(viewModel: hourBlockViewModel,
                                  onBlockCleared: { viewModel.clearBlock(hourBlockViewModel.hourBlock) })
                } else {
                    EmptyHourBlockView(viewModel: hourBlockViewModel,
                                       onNewBlockAdded: { viewModel.addBlock($0) })
                }
            }
        }
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}
