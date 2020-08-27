//
//  NewScheduleView.swift
//  Hour Blocks
//
//  Created by James Saeed on 01/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI
import SwiftDate

struct ScheduleView: View {
    
    let refreshSchedulePublisher = NotificationCenter.default.publisher(for: NSNotification.Name("RefreshSchedule"))
    let refreshHourPublisher = NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
    
    @StateObject var viewModel = ScheduleViewModel()
    
    var body: some View {
        VStack {
            HeaderView(title: "Schedule", subtitle: viewModel.currentDate.getFormattedDate()) {
                HStack(spacing: 16) {
                    if !viewModel.isCurrentDayToday() {
                        IconButton(iconName: "arrow.uturn.left",
                                   iconWeight: .medium,
                                   action: viewModel.returnToToday)
                    }
                    IconButton(iconName: "calendar",
                               action: viewModel.presentDatePickerView)
                }
            }
            .gesture(DragGesture(minimumDistance: 128, coordinateSpace: .local).onEnded { drag in
                if drag.translation.width > 0 {
                    viewModel.regressDate()
                } else {
                    viewModel.advanceDate()
                }
            })
            .sheet(isPresented: $viewModel.isDatePickerViewPresented) {
                ScheduleDatePicker(isPresented: $viewModel.isDatePickerViewPresented,
                                   scheduleDate: $viewModel.currentDate,
                                   onDateChanged: viewModel.loadHourBlocks)
            }
            ScheduleBlocksListView(viewModel: viewModel)
        }.onAppear(perform: viewModel.handleCalendarPermissions)
        .onReceive(refreshSchedulePublisher) { _ in viewModel.loadHourBlocks() }
        .onReceive(refreshHourPublisher) { _ in viewModel.updateCurrentHour() }
    }
}

private struct ScheduleBlocksListView: View {
    
    @ObservedObject var viewModel: ScheduleViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                if let tip = viewModel.currentTip {
                    TipCardView(tip: tip, onDismiss: viewModel.dismissTip)
                    NeonDivider().padding(.horizontal, 32)
                }
                
                ForEach(viewModel.todaysCalendarBlocks.filter { $0.endDate.toLocalTime().hour >= (viewModel.isCurrentDayToday() ? viewModel.currentHour : UtilGateway.shared.dayStartHour()) }, id: \.self) { event in
                    CalendarBlockView(event: event)
                }
                
                if (viewModel.todaysCalendarBlocks.filter { $0.endDate.toLocalTime().hour >= (viewModel.isCurrentDayToday() ? viewModel.currentHour : UtilGateway.shared.dayStartHour()) }).count > 0 {
                    NeonDivider().padding(.horizontal, 32)
                }
                
                ForEach(viewModel.todaysHourBlocks.filter { $0.hourBlock.hour >= (viewModel.isCurrentDayToday() ?  viewModel.currentHour : UtilGateway.shared.dayStartHour()) }) { hourBlockViewModel in
                    if hourBlockViewModel.title != "Empty" {
                        HourBlockView(viewModel: hourBlockViewModel,
                                      onBlockCleared: { viewModel.clearBlock(hourBlockViewModel.hourBlock) })
                    } else {
                        EmptyHourBlockView(viewModel: hourBlockViewModel,
                                           onNewBlockAdded: { viewModel.addBlock($0) })
                    }
                }
            }.padding(.top, 8)
            .padding(.bottom, 24)
        }
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}
