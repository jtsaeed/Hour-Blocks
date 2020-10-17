//
//  NewScheduleDatePicker.swift
//  Hour Blocks
//
//  Created by James Saeed on 02/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct ScheduleDatePicker: View {
    
    @Binding private var isPresented: Bool
    @Binding private var scheduleDate: Date
    
    private let onDateChanged: () -> Void
    
    @StateObject private var viewModel: ScheduleDatePickerViewModel
    
    init(isPresented: Binding<Bool>, scheduleDate: Binding<Date>, onDateChanged: @escaping () -> Void) {
        self._isPresented = isPresented
        self._scheduleDate = scheduleDate
        self._viewModel = StateObject<ScheduleDatePickerViewModel>(wrappedValue: ScheduleDatePickerViewModel(initialSelectedDate: scheduleDate.wrappedValue))
        self.onDateChanged = onDateChanged
    }
    
    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { geometry in
                    DatePicker("Picker", selection: $viewModel.selectedDate, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .frame(maxHeight: geometry.size.width)
                        .accentColor(Color("AccentColor"))
                        .onChange(of: viewModel.selectedDate) { _ in
                            viewModel.loadHourBlocks()
                        }
                }.padding(.horizontal, 24)
                .padding(.top, 20)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
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
                    }.padding(.top, 8)
                    .padding(.bottom, 24)
                }.padding(.top, UIDevice.current.hasNotch ? 0 : 40)
            }
            .navigationBarTitle("Date Picker", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel", action: dismiss),
                                trailing: Button("Save", action: save))
        }.accentColor(Color("AccentColor"))
    }
    
    func save() {
        scheduleDate = viewModel.selectedDate
        onDateChanged()
        dismiss()
    }
    
    func dismiss() {
        isPresented = false
    }
}

struct ScheduleDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleDatePicker(isPresented: .constant(true), scheduleDate: .constant(Date()), onDateChanged: {})
    }
}
