//
//  NewScheduleView.swift
//  neon
//
//  Created by James Saeed on 09/02/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct ScheduleView: View {
    
    @EnvironmentObject var viewModel: ScheduleViewModel
    
    @State var isDatePickerPresented = false
    
    var body: some View {
        NavigationView {
            VStack {
                ScheduleHeader(isDatePickerPresented: $isDatePickerPresented)
                List {
                    if viewModel.currentTip != nil {
                        TipBlockCard(tip: $viewModel.currentTip)
                    }
                    ForEach(viewModel.currentHourBlocks.filter { $0.hour >=  viewModel.currentHour }) { hourBlock in
                        if hourBlock.title != nil {
                            HourBlockCard(hourBlock: hourBlock)
                        } else {
                            EmptyHourBlockCard(hourBlock: hourBlock)
                        }
                    }
                }
            }
            .navigationBarTitle("Schedule")
            .navigationBarHidden(true)
            .sheet(isPresented: $isDatePickerPresented) {
                ScheduleDatePicker(isDatePickerPresented: self.$isDatePickerPresented,
                                   currentDate: self.$viewModel.currentDate,
                                   currentHour: self.$viewModel.currentHour,
                                   dismissed: self.viewModel.loadHourBlocks)
            }
        }.navigationViewStyle(StackNavigationViewStyle())
        .onAppear(perform: {
            CalendarGateway.shared.handlePermissions {
                self.viewModel.loadHourBlocks()
            }
        })
    }
}

private struct ScheduleHeader: View {
    
    @EnvironmentObject var viewModel: ScheduleViewModel
    
    @Binding var isDatePickerPresented: Bool
    
    var body: some View {
        Header(title: viewModel.currentDate.getRelativeDateToToday(),
               subtitle: viewModel.allDayEvent?.title ?? viewModel.currentDate.getFormattedDate(),
               content: { IconButton(iconName: "calendar_item",
                                     action: self.presentDatePicker) })
    }
    
    func presentDatePicker() {
        HapticsGateway.shared.triggerLightImpact()
        isDatePickerPresented = true
    }
}
