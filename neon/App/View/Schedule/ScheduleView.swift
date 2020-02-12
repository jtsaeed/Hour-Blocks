//
//  NewScheduleView.swift
//  neon
//
//  Created by James Saeed on 09/02/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct ScheduleView: View {
    
    @ObservedObject var viewModel = ScheduleViewModel()
    
    @State var isDatePickerPresented = false
    
    var body: some View {
        NavigationView {
            VStack {
                ScheduleHeader(viewModel: viewModel, isDatePickerPresented: $isDatePickerPresented)
                List(viewModel.currentHourBlocks) { hourBlock in
                    HourBlockCard(viewModel: self.viewModel,
                                  hourBlock: hourBlock)
                }
            }
            .navigationBarTitle("Schedule")
            .navigationBarHidden(true)
            .sheet(isPresented: $isDatePickerPresented) {
                ScheduleDatePicker(isDatePickerPresented: self.$isDatePickerPresented,
                                   currentDate: self.$viewModel.currentDate,
                                   dismissed: self.viewModel.loadHourBlocks)
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

private struct ScheduleHeader: View {
    
    @ObservedObject var viewModel: ScheduleViewModel
    
    @Binding var isDatePickerPresented: Bool
    
    var body: some View {
        Header(title: viewModel.currentDate.getRelativeDateToToday(),
               subtitle: viewModel.currentDate.getFormattedDate(),
               content: { IconButton(iconName: "calendar_item",
                                     action: self.presentDatePicker) })
    }
    
    func presentDatePicker() {
        HapticsGateway.shared.triggerLightImpact()
        isDatePickerPresented = true
    }
}
