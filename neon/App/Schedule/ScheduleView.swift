//
//  ScheduleView.swift
//  neon3
//
//  Created by James Saeed on 18/06/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import SwiftUI

struct ScheduleView: View {
    
    @EnvironmentObject var blocks: HourBlocksStore
    @EnvironmentObject var suggestions: SuggestionsStore
    @EnvironmentObject var settings: SettingsStore
    
    @State var currentHour = Calendar.current.component(.hour, from: Date())
    
    @State var isNewFutureBlockPresented = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: TodayHeader(allDayEvent: $blocks.allDayEvent)) {
                    ForEach(blocks.todaysBlocks.filter { $0.hour >=  currentHour }, id: \.self) { block in
                        TodayCard(currentBlock: block).environmentObject(self.blocks)
                    }
                }
                Section(header: FutureHeader(addButtonDisabled: blocks.futureBlocks.isEmpty)) {
                    if blocks.futureBlocks.isEmpty {
                        EmptyFutureCard()
                    } else {
                        ForEach(blocks.futureBlocks.sorted { $0.day < $1.day }, id: \.self) { block in
                            FutureCard(currentBlock: block)
                        }
                    }
                }
            }
            .navigationBarTitle("Schedule")
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            CalendarGateway.shared.handlePermissions {
                self.blocks.reloadTodayBlocks()
                self.blocks.reloadFutureBlocks()
            }
            
            self.currentHour = Calendar.current.component(.hour, from: Date())
        }
    }
}
