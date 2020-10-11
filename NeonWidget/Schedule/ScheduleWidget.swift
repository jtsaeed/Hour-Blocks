//
//  NeonWidget.swift
//  NeonWidget
//
//  Created by James Saeed on 15/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import WidgetKit
import SwiftUI
import CoreData

struct ScheduleWidget: Widget {
    private let kind: String = "ScheduleWidget"

    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ScheduleProvider()) { entry in
            ScheduleWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Upcoming Schedule")
        .description("Take a quick peek at your upcoming schedule for the day")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct ScheduleWidgetEntryView : View {
    
    var entry: ScheduleProvider.Entry
    
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall: UpcomingScheduleView(hourBlock: entry.hourBlock, subBlocks: nil)
        case .systemMedium: UpcomingScheduleView(hourBlock: entry.hourBlock, subBlocks: entry.subBlocks)
        default: UpcomingScheduleView(hourBlock: entry.hourBlock, subBlocks: nil)
        }
    }
}

struct SchedulePlaceholderView : View {
    
    var body: some View {
        PlaceholderUpcomingScheduleView()
    }
}

struct HourBlockEntry: TimelineEntry {
    
    public let date: Date
    let hourBlock: HourBlock?
    let subBlocks: [SubBlock]
    let relevance: TimelineEntryRelevance?
}

struct ScheduleProvider: TimelineProvider {
    
    public typealias Entry = HourBlockEntry
    
    public func placeholder(in context: Context) -> HourBlockEntry {
        return HourBlockEntry(date: Date(), hourBlock: nil, subBlocks: [], relevance: TimelineEntryRelevance(score: 0))
    }
    
    public func getSnapshot(in context: Context, completion: @escaping (HourBlockEntry) -> Void) {
        let hourBlocks = WidgetDataGateway.shared.getHourBlocks(for: Date()).sorted { $0.hour < $1.hour }
        
        if let firstBlock = hourBlocks.first {
            let subBlocks = WidgetDataGateway.shared.getSubBlocks(for: firstBlock)
                
            let entry = HourBlockEntry(date: Date(),
                                    hourBlock: firstBlock,
                                    subBlocks: subBlocks,
                                    relevance: TimelineEntryRelevance(score: 0))
            completion(entry)
        } else {
            let entry = HourBlockEntry(date: Date(),
                                       hourBlock: nil,
                                       subBlocks: [],
                                       relevance: nil)
            completion(entry)
        }
    }
    
    public func getTimeline(in context: Context, completion: @escaping (Timeline<HourBlockEntry>) -> Void) {
        var entries: [HourBlockEntry] = []
        
        let hourBlocks = WidgetDataGateway.shared.getHourBlocks(for: Date())
            .filter { $0.hour >= Calendar.current.component(.hour, from: Date()) }
            .sorted { $0.hour < $1.hour }
        
        if let firstBlock = hourBlocks.first {
            let currentDate = Date()
            
            let hourDifference = firstBlock.hour - Calendar.current.component(.hour, from: currentDate)
            let entryScore = hourDifference < 2 ? 30 : 24 - hourDifference
            let subBlocks = WidgetDataGateway.shared.getSubBlocks(for: firstBlock)
            let firstEntry = HourBlockEntry(date: currentDate,
                                            hourBlock: firstBlock,
                                            subBlocks: subBlocks,
                                            relevance: TimelineEntryRelevance(score: Float(entryScore)))
            entries.append(firstEntry)
            
            if hourBlocks.count > 1 {
                for index in 1 ..< hourBlocks.count {
                    let entryDate = Calendar.current.date(bySettingHour: hourBlocks[index - 1].hour + 1,
                                                              minute: 0,
                                                              second: 0,
                                                              of: currentDate)!
                    let hourDifference = hourBlocks[index].hour - Calendar.current.component(.hour, from: currentDate)
                    let entryScore = hourDifference < 2 ? 30 : 24 - hourDifference
                    let subBlocks = WidgetDataGateway.shared.getSubBlocks(for: hourBlocks[index])
                    let entry = HourBlockEntry(date: entryDate,
                                               hourBlock: hourBlocks[index],
                                               subBlocks: subBlocks,
                                               relevance: TimelineEntryRelevance(score: Float(entryScore)))
                    entries.append(entry)
                }
            }
        } else {
            entries.append(HourBlockEntry(date: Date(),
                                          hourBlock: nil,
                                          subBlocks: [],
                                          relevance: nil))
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct ScheduleWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            UpcomingScheduleView(hourBlock: HourBlock(day: Date(),
                                                      hour: 19,
                                                      title: "Dinner with Bonnie",
                                                      icon: .food),
                                 subBlocks: nil)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
        }
    }
}
