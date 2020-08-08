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
    
    @StateObject var viewModel = ScheduleViewModel()
    
    var body: some View {
        VStack {
            HeaderView(title: "Schedule", subtitle: viewModel.currentDate.getFormattedDate()) {
                HStack(spacing: 16) {
                    IconButton(iconName: "arrow.up",
                                  iconWeight: .semibold,
                                  action: withAnimation { viewModel.toggleFilter })
                        .rotationEffect(Angle(degrees: viewModel.isFilterEnabled ? 0 : 180))
                    IconButton(iconName: "calendar", action: viewModel.presentDatePickerView)
                }
            }.sheet(isPresented: $viewModel.isDatePickerViewPresented) {
                ScheduleDatePicker(isPresented: $viewModel.isDatePickerViewPresented,
                                   scheduleDate: $viewModel.currentDate,
                                   onDateChanged: viewModel.loadHourBlocks)
            }
            
            ScheduleBlocksListView(viewModel: viewModel)
        }.onAppear(perform: viewModel.handleCalendarPermissions)
        .navigationBarHidden(true)
    }
}

private struct ScheduleBlocksListView: View {
    
    @ObservedObject var viewModel: ScheduleViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                ForEach(viewModel.isFilterEnabled ? viewModel.todaysCalendarBlocks.filter { $0.endDate.hour >= viewModel.currentHour } : viewModel.todaysCalendarBlocks, id: \.self) { event in
                    CalendarBlockView(event: event)
                }
                
                if (viewModel.isFilterEnabled ? viewModel.todaysCalendarBlocks.filter { $0.endDate.hour >= viewModel.currentHour } : viewModel.todaysCalendarBlocks).count > 0 {
                    NeonDivider().padding(.horizontal, 32)
                }
                
                ForEach(viewModel.isFilterEnabled ? viewModel.todaysHourBlocks.filter { $0.hourBlock.hour >= viewModel.currentHour } : viewModel.todaysHourBlocks) { hourBlockViewModel in
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
