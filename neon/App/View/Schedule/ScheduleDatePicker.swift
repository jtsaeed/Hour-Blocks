//
//  ScheduleDatePicker.swift
//  neon
//
//  Created by James Saeed on 11/02/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI
import SwiftDate

struct ScheduleDatePicker: View {
    
    @Binding var isDatePickerPresented: Bool
    @Binding var currentDate: Date
    
    @ObservedObject var viewModel = DatePickerViewModel()
    
    let dismissed: () -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(showsIndicators: false) {
                    ForEach(viewModel.browsingMonth) { date in
                        DateCard(date: date, selected: {
                            self.select(date)
                        })
                    }
                }
                ScheduleDatePickerToolbar(viewModel: viewModel)
                .padding(.vertical, 8)
                .padding(.horizontal, 32)
            }
            .navigationBarTitle(viewModel.browsingDate.getMonthAndYear())
            .navigationBarItems(leading: Button(action: dismiss, label: {
                Text("Cancel")
            }), trailing: Button(action: backToToday, label: {
                Text("Back to Today")
            }))
        }.accentColor(Color("primary"))
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func select(_ date: Date) {
        HapticsGateway.shared.triggerLightImpact()
        currentDate = Calendar.current.startOfDay(for: date)
        dismissed()
        dismiss()
    }
    
    func backToToday() {
        HapticsGateway.shared.triggerLightImpact()
        currentDate = Calendar.current.startOfDay(for: Date())
        dismissed()
        dismiss()
    }
    
    func dismiss() {
        isDatePickerPresented = false
    }
}

private struct DateCard: View {
    
    let date: Date
    let selected: () -> Void
    
    var body: some View {
        Card {
            HStack {
                CardLabels(title: self.date.getFormattedDate(),
                           subtitle: self.date.getRelativeDateToToday())
                Spacer()
                IconButton(iconName: "calendar_item",
                           action: self.selected)
            }
        }.padding(.horizontal, 16)
    }
}

private struct ScheduleDatePickerToolbar: View {
    
    @ObservedObject var viewModel: DatePickerViewModel
    
    var body: some View {
        HStack {
            ScheduleDatePickerToolbarButton(text: $viewModel.previousMonth,
                                            iconName: "arrow.left",
                                            action: viewModel.browsePreviousMonth)
            Spacer()
            ScheduleDatePickerToolbarButton(text: $viewModel.nextMonth,
                                            iconName: "arrow.right",
                                            action: viewModel.browseNextMonth)
        }
    }
}

private struct ScheduleDatePickerToolbarButton: View {
    
    @Binding var text: String
    
    let iconName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                if iconName != "arrow.left" {
                    Text(text)
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                }
                Image(systemName: iconName)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .padding(.leading, 4)
                if iconName != "arrow.right" {
                    Text(text)
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                }
            }
        }
    }
}
