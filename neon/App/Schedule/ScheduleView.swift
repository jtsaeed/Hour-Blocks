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
    
    @State var showBlocks = 0
    @State var isNewFutureBlockPresented = false
    
    init() {
        CalendarGateway.shared.handlePermissions()
    }
    
    var body: some View {
        List {
            Section(header: TodayHeader(showBlocks: $showBlocks, showBlockTogglePressed: {
                self.cycleShowBlocks()
            })) {
                ForEach(blocks.todaysBlocks.filter { $0.hour >= Calendar.current.component(.hour, from: Date()) && showQuarterBlocks(minute: $0.minute) }, id: \.self) { block in
                    TodayCard(currentBlock: block, didAddBlock: { title in
                        self.blocks.setTodayBlock(for: block.hour, block.minute, with: title)
                    }, didRemoveBlock: {
                        self.blocks.removeTodayBlock(for: block.hour, block.minute)
                    }).environmentObject(self.blocks)
                }
            }
            Section(header: FutureHeader(futureBlockAdded: { (title, date) in self.blocks.addFutureBlock(for: date, 0, .oclock, with: title)})) {
                ForEach(blocks.futureBlocks, id: \.self) { block in
                    FutureCard(currentBlock: block)
                        .contextMenu {
                            Button(action: {
                                // TODO: Rename
                            }) {
                                Text("Rename")
                                Image(systemName: "pencil")
                            }
                            Button(action: {
                                // TODO: Clear
                            }) {
                                Text("Clear")
                                Image(systemName: "trash")
                            }
                        }
                }
            }
            Rectangle().foregroundColor(Color.white).frame(height: 4)
        }
    }
    
    func cycleShowBlocks() {
        if showBlocks == 0 {
            showBlocks = 1
        } else if showBlocks == 1 {
            showBlocks = 2
        } else if showBlocks == 2 {
            showBlocks = 0
        }
    }
    
    func showQuarterBlocks(minute: BlockMinute) -> Bool {
        if showBlocks == 0 {
            return minute == .oclock
        } else if showBlocks == 1 {
            return minute == .oclock || minute == .halfPast
        } else if showBlocks == 2 {
            return true
        }
        
        return false
    }
}

#if DEBUG
struct ScheduleView_Previews : PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}
#endif
