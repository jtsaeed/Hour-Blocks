//
//  WatchScheduleView.swift
//  neonWatch Extension
//
//  Created by James Saeed on 10/03/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct WatchScheduleView: View {
    
    @ObservedObject var viewModel = ScheduleViewModel()
    
    var body: some View {
        List(viewModel.currentHourBlocks.filter { $0.hour >= viewModel.currentHour }) { hourBlock in
            if hourBlock.title != nil {
                WatchHourBlockCard(hourBlock: hourBlock)
            } else {
                WatchEmptyHourBlockCard(hourBlock: hourBlock)
            }
        }.navigationBarTitle("Today")
    }
}

private struct WatchEmptyHourBlockCard: View {
    
    let hourBlock: HourBlock
    
    var body: some View {
        HStack {
            Button(action: { }) {
                Text("Add")
            }
            Spacer()
            Text(hourBlock.formattedTime).fontWeight(.bold)
        }
    }
}

private struct WatchHourBlockCard: View {
    
    let hourBlock: HourBlock
    
    var body: some View {
        HStack {
            Text(hourBlock.title!.smartCapitalization())
            Spacer()
            Text(hourBlock.formattedTime).fontWeight(.bold)
        }
    }
}
