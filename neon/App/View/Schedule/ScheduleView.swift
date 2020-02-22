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
                    .gesture(DragGesture(minimumDistance: 64).onEnded({ gesture in
                        self.handleHeaderSwipe(gesture)
                    }))
                List {
                    if viewModel.currentTip != nil {
                        TipBlockCard(tip: $viewModel.currentTip)
                    }
                    ForEach(viewModel.currentHourBlocks.filter { $0.hour >= viewModel.currentHour }) { hourBlock in
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
    
    func handleHeaderSwipe(_ gesture: DragGesture.Value) {
        HapticsGateway.shared.triggerSwipeHaptic()
        
        if gesture.translation.width < 0 {
            viewModel.nextDay()
        } else {
            viewModel.previousDay()
        }
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
