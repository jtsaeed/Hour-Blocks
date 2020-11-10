//
//  NewScheduleDatePicker.swift
//  Hour Blocks
//
//  Created by James Saeed on 02/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

/// A date picker view for the schedule.
struct ScheduleDatePicker: View {
    
    @ObservedObject private var viewModel: ScheduleDatePickerViewModel
    
    @Binding private var isPresented: Bool
    @Binding private var currentScheduleDate: Date
    
    private let onDateChanged: () -> Void
    
    /// Creates an instance of the ScheduleDatePicker view.
    ///
    /// - Parameters:
    ///   - isPresented: A binding determining whether or not the view is presented.
    ///   - currentScheduleDate: The current date of the schedule.
    ///   - onDateChanged: The callback function to be triggered when the user has selected a date.
    init(isPresented: Binding<Bool>, currentScheduleDate: Binding<Date>, onDateChanged: @escaping () -> Void) {
        self.viewModel = ScheduleDatePickerViewModel(initialSelectedDate: currentScheduleDate.wrappedValue)
        self._isPresented = isPresented
        self._currentScheduleDate = currentScheduleDate
        self.onDateChanged = onDateChanged
    }
    
    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { geometry in
                    DatePicker("", selection: $viewModel.selectedDate, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .frame(maxHeight: geometry.size.width)
                        .accentColor(Color(AppStrings.Colors.accent))
                        .onChange(of: viewModel.selectedDate) { _ in viewModel.loadHourBlocks() }
                }.padding(.horizontal, 24)
                .padding(.top, 20)
                
                CardsListView {
                    ForEach(viewModel.calendarBlocks) { event in
                        CalendarBlockView(for: event)
                    }
                    
                    if !viewModel.calendarBlocks.isEmpty && !viewModel.hourBlocks.isEmpty {
                        NeonDivider().padding(.horizontal, 32)
                    }
                    
                    ForEach(viewModel.hourBlocks) { hourBlockViewModel in
                        CompactHourBlockView(viewModel: hourBlockViewModel)
                    }
                    
                    if viewModel.calendarBlocks.isEmpty && viewModel.hourBlocks.isEmpty {
                        NoHourBlocksView()
                    }
                }.padding(.top, UIDevice.current.hasNotch ? 0 : 40)
            }.navigationBarTitle(AppStrings.Schedule.datePickerHeader, displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(AppStrings.Global.cancel, action: dismiss)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(AppStrings.Global.save, action: save)
                }
            }
        }.accentColor(Color(AppStrings.Colors.accent))
    }
    
    /// Updates the schedule's current date then dismisses the view.
    private func save() {
        currentScheduleDate = viewModel.selectedDate
        onDateChanged()
        dismiss()
    }
    
    /// Dismisses the current view.
    private func dismiss() {
        isPresented = false
    }
}

struct ScheduleDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleDatePicker(isPresented: .constant(true), currentScheduleDate: .constant(Date()), onDateChanged: {})
    }
}
