//
//  ToDoWidget.swift
//  NeonWidgetExtension
//
//  Created by James Saeed on 09/10/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import WidgetKit
import SwiftUI
import CoreData

struct ToDoWidget: Widget {
    private let kind: String = "ToDoWidget"
    
    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ToDoProvider()) { entry in
            ToDoWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("To Do List")
        .description("Take a quick peek at your To Do List")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct ToDoWidgetEntryView : View {
    
    var entry: ToDoProvider.Entry
    
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        CurrentToDoListView(todos: entry.toDoItems)
    }
}

struct ToDoPlaceholderView : View {
    
    var body: some View {
        PlaceholderCurrentToDoListView()
    }
}

struct ToDoItemsEntry: TimelineEntry {
    
    public let date: Date
    let toDoItems: [ToDoItem]
    let relevance: TimelineEntryRelevance?
}

struct ToDoProvider: TimelineProvider {
    
    public typealias Entry = ToDoItemsEntry
    
    public func placeholder(in context: Context) -> ToDoItemsEntry {
        return ToDoItemsEntry(date: Date(), toDoItems: [], relevance: TimelineEntryRelevance(score: 0))
    }
    
    public func getSnapshot(in context: Context, completion: @escaping (ToDoItemsEntry) -> Void) {
        var todos = WidgetDataGateway.shared.getToDoItems()
        todos.sort( by: { $0.title < $1.title })
        
        let entry = ToDoItemsEntry(date: Date(), toDoItems: todos, relevance: TimelineEntryRelevance(score: 0))
        completion(entry)
    }
    
    public func getTimeline(in context: Context, completion: @escaping (Timeline<ToDoItemsEntry>) -> Void) {
        var todos = WidgetDataGateway.shared.getToDoItems()
        todos.sort( by: { $0.title < $1.title })
        
        var score: Float = 0.0
        todos.forEach { item in
            switch item.urgency {
            case .whenever: score += 1
            case .soon: score += 3
            case .urgent: score += 5
            }
        }
        
        let entry = ToDoItemsEntry(date: Date(), toDoItems: todos, relevance: TimelineEntryRelevance(score: score))
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
    
}

struct ToDoWidget_Previews: PreviewProvider {
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
