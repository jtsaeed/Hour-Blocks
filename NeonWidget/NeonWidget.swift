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
    public typealias Entry = SimpleEntry

    public func snapshot(with context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(),
                                hourBlock: HourBlock(day: Date(), hour: 19, title: "Dinner with Bonnie"),
                                relevance: TimelineEntryRelevance(score: 0))
        completion(entry)
    }

    public func timeline(with context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        let blocks = WidgetDataGateway.shared.getHourBlocks(for: Date())

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate,
                                    hourBlock: blocks.first!,
                                    relevance: TimelineEntryRelevance(score: 0))
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    public let date: Date
    let hourBlock: HourBlock
    let relevance: TimelineEntryRelevance?
}

struct PlaceholderView : View {
    
    var body: some View {
        NeonWidgetEntryView(entry: SimpleEntry(date: Date(),
                                               hourBlock: HourBlock(day: Date(),
                                                                    hour: 19,
                                                                    title: "Dinner with Bonnie"),
                                               relevance: TimelineEntryRelevance(score: 0)))
    }
}

struct NeonWidgetEntryView : View {
    
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var family

    @ViewBuilder
    var body: some View {
        switch family {
            case .systemSmall: UpcomingScheduleView(hourBlock: entry.hourBlock)
            case .systemMedium: UpcomingScheduleView(hourBlock: entry.hourBlock)
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
        .description("Take a quick peek at your upcoming schedule")
        .supportedFamilies([.systemSmall])
    }
}

struct NeonWidget_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingScheduleView(hourBlock: HourBlock(day: Date(),
                                                  hour: 19,
                                                  title: "Dinner with Bonnie"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
