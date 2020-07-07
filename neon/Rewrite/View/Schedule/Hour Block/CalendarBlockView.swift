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
        NewCard {
            HStack {
                NewCardLabels(title: event.title,
                              subtitle: "\(event.startDate.getFormattedTime(militaryTime: false)) TO \(event.endDate.getFormattedTime(militaryTime: false))")
                Spacer()
                HourBlockIcon(name: "calendar_item")
            }
        }.padding(.horizontal, 24)
        .onTapGesture {
            UIApplication.shared.open(event.url!)
        }
    }
}
