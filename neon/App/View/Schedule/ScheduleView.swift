//
//  ScheduleView.swift
//  neon3
//
//  Created by James Saeed on 18/06/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import SwiftUI

struct ScheduleView: View {
    
    @EnvironmentObject var viewModel: ScheduleViewModel
    @EnvironmentObject var suggestionsViewModel: SuggestionsViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    @State var currentHour = Calendar.current.component(.hour, from: Date())
    
    @State var isNewFutureBlockPresented = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: TodayHeader(allDayEvent: $viewModel.allDayEvent)) {
                    ForEach(viewModel.todaysBlocks.filter { $0.hour >=  currentHour }, id: \.self) { block in
                        TodayCard(currentBlock: block).environmentObject(self.viewModel)
                    }
                }
                Section(header: FutureHeader(addButtonDisabled: viewModel.futureBlocks.isEmpty)) {
                    if viewModel.futureBlocks.isEmpty {
                        EmptyFutureCard()
                    } else {
                        ForEach(viewModel.futureBlocks.sorted { $0.day < $1.day }, id: \.self) { block in
                            FutureCard(currentBlock: block)
                        }
                    }
                }
            }
            .navigationBarTitle("Schedule")
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear(perform: updateCurrentHour)
    }
    
    func updateCurrentHour() {
        CalendarGateway.shared.handlePermissions {
            self.viewModel.reloadTodayBlocks()
            self.viewModel.reloadFutureBlocks()
        }
        
        currentHour = Calendar.current.component(.hour, from: Date())
    }
}

private struct TodayHeader: View {
    
    @Binding var allDayEvent: String
    
    var body: some View {
        Header(title: "Today", subtitle: allDayEvent != "" ? allDayEvent : Date().getFormattedDate()) {
            EmptyView()
        }
    }
}

private struct FutureHeader: View {
    
    @EnvironmentObject var viewModel: ScheduleViewModel
    
    @State var isPresented = false
    
    var addButtonDisabled: Bool
    
    var body: some View {
        Header(title: "The Future", subtitle: "A month into") {
            if !self.addButtonDisabled {
                Button(action: self.add) {
                    Image("add_button")
                }
                .padding(.top, 32)
                .padding(.trailing, 47)
                .sheet(isPresented: self.$isPresented, content: {
                    NewFutureBlockView(isPresented: self.$isPresented)
                        .environmentObject(self.viewModel)
                })
            }
        }
    }
    
    func add() {
        HapticsGateway.shared.triggerLightImpact()
        isPresented.toggle()
    }
}
