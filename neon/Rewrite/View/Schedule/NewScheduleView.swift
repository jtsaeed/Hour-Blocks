//
//  NewScheduleView.swift
//  Hour Blocks
//
//  Created by James Saeed on 01/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct NewScheduleView: View {
    
    @StateObject var viewModel = NewScheduleViewModel()
    
    var body: some View {
        VStack {
            NewHeaderView(title: "Schedule", subtitle: viewModel.currentDate.getFormattedDate()) {
                HStack(spacing: 16) {
                    NewIconButton(iconName: "arrow.up",
                                  iconWeight: .semibold,
                                  action: withAnimation { viewModel.toggleFilter })
                        .rotationEffect(Angle(degrees: viewModel.isFilterEnabled ? 0 : 180))
                    NewIconButton(iconName: "calendar", action: viewModel.presentDatePickerView)
                }
            }.sheet(isPresented: $viewModel.isDatePickerViewPresented) {
                NewScheduleDatePicker(viewModel: viewModel)
            }
            
            ScheduleBlocksListView(viewModel: viewModel)
        }
    }
}

private struct ScheduleBlocksListView: View {
    
    @ObservedObject var viewModel: NewScheduleViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 24) {
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
        NewScheduleView(viewModel: NewScheduleViewModel())
    }
}
