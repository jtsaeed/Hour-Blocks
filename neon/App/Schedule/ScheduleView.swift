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
    
    @State var isNewFutureBlockPresented = false
    
    init() {
        CalendarGateway.shared.handlePermissions()
    }
    
    var body: some View {
        List {
            Section(header: TodayHeader(allDayEvent: $blocks.allDayEvent)) {
                ForEach(blocks.todaysBlocks.filter { $0.hour >= Calendar.current.component(.hour, from: Date()) }, id: \.self) { block in
                    TodayCard(currentBlock: block, didAddBlock: { title in
                        self.blocks.setTodayBlock(for: block.hour, with: title)
                    }, didRemoveBlock: {
                        self.blocks.removeTodayBlock(for: block.hour)
                    }).environmentObject(self.blocks)
                }
            }
            Section(header: FutureHeader(addButtonDisabled: blocks.futureBlocks.isEmpty, futureBlockAdded: { title, hour, date in self.blocks.addFutureBlock(for: date, hour, with: title)})) {
                if blocks.futureBlocks.isEmpty {
                    EmptyFutureCard { title, hour, date in
                        self.blocks.addFutureBlock(for: date, hour, with: title)
                    }
                } else {
                    ForEach(blocks.futureBlocks.sorted { $0.day < $1.day }, id: \.self) { block in
                        FutureCard(currentBlock: block, didRemoveBlock: {
                            self.blocks.removeFutureBlock(for: block)
                        })
                    }
                }
            }
        }
    }
}

#if DEBUG
struct ScheduleView_Previews : PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}
#endif
