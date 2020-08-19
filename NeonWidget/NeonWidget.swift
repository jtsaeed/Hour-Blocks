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

struct Provider: TimelineProvider {
    
    public typealias Entry = HourBlockEntry
    
    public func placeholder(in context: Context) -> HourBlockEntry {
        return HourBlockEntry(date: Date(), hourBlock: nil, relevance: TimelineEntryRelevance(score: 0))
    }
    
    public func getSnapshot(in context: Context, completion: @escaping (HourBlockEntry) -> Void) {
        let hourBlocks = WidgetDataGateway.shared.getHourBlocks(for: Date()).sorted { $0.hour < $1.hour }
        
        if let firstBlock = hourBlocks.first {
            let entry = HourBlockEntry(date: Date(),
                                    hourBlock: firstBlock,
                                    relevance: TimelineEntryRelevance(score: 0))
            completion(entry)
        } else {
            let entry = HourBlockEntry(date: Date(),
                                       hourBlock: nil,
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
            let firstEntry = HourBlockEntry(date: currentDate,
                                            hourBlock: firstBlock,
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
                    let entry = HourBlockEntry(date: entryDate,
                                               hourBlock: hourBlocks[index],
                                               relevance: TimelineEntryRelevance(score: Float(entryScore)))
                    entries.append(entry)
                }
            }
        } else {
            entries.append(HourBlockEntry(date: Date(),
                                          hourBlock: nil,
                                          relevance: nil))
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct HourBlockEntry: TimelineEntry {
    
    public let date: Date
    let hourBlock: HourBlock?
    let relevance: TimelineEntryRelevance?
}

struct PlaceholderView : View {
    
    var body: some View {
        PlaceholderUpcomingScheduleView()
    }
}

struct NeonWidgetEntryView : View {
    
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var family

    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall: UpcomingScheduleView(hourBlock: entry.hourBlock)
        case .systemMedium: UpcomingScheduleView(hourBlock: entry.hourBlock, small: false)
        default: UpcomingScheduleView(hourBlock: entry.hourBlock)
        }
    }
}

@main
struct NeonWidget: Widget {
    private let kind: String = "NeonWidget"

    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            NeonWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Upcoming Schedule")
        .description("Take a quick peek at your upcoming schedule for the day")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct NeonWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            UpcomingScheduleView(hourBlock: HourBlock(day: Date(),
                                                      hour: 19,
                                                      title: "Dinner with Bonnie",
                                                      icon: .food))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
    
            UpcomingScheduleView(hourBlock: HourBlock(day: Date(),
                                                      hour: 19,
                                                      title: "Dinner with Bonnie",
                                                      icon: .food), small: false)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
        }
    }
}
