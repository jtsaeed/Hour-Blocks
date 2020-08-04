//
//  CalendarBlockView.swift
//  Hour Blocks
//
//  Created by James Saeed on 06/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI
import EventKit

struct CalendarBlockView: View {
    
    let event: EKEvent
    
    var body: some View {
        Card {
            HStack {
                CardLabels(title: event.title,
                           subtitle: "\(event.startDate.getFullFormattedTime(militaryTime: false)) TO \(event.endDate.getFullFormattedTime(militaryTime: false))")
                Spacer()
                HourBlockIcon(name: "calendar_item")
            }
        }.padding(.horizontal, 24)
    }
}
