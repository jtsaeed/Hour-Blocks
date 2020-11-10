//
//  AppPublishers.swift
//  Hour Blocks
//
//  Created by James Saeed on 26/10/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import UIKit

/// A structure containing publishers used throughout the app.
struct AppPublishers {
    
    struct Names {
        static let refreshSchedule = "RefreshSchedule"
        static let refreshToDoList = "RefreshToDoList"
        
        static let scheduleWidgetTimeline = "ScheduleWidget"
        static let toDoListWidgetTimeline = "ToDoWidget"
    }
    
    static let refreshSchedulePublisher = NotificationCenter.default.publisher(for: NSNotification.Name(Names.refreshSchedule))
    static let refreshOnLaunchPublisher = NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
    
    static let refreshToDoListPublisher = NotificationCenter.default.publisher(for: NSNotification.Name(Names.refreshToDoList))
}
