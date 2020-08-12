//
//  RemindersGateway.swift
//  Hour Blocks
//
//  Created by James Saeed on 04/08/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import Foundation
import UserNotifications

protocol RemindersGatewayProtocol {
    
    func setReminder(for hourBlock: HourBlock)
    func removeReminder(for hourBlock: HourBlock)
}

struct RemindersGateway: RemindersGatewayProtocol {
    
    func setReminder(for hourBlock: HourBlock) {
        hasPermissions { result in
            guard result == true else { return }
            guard UserDefaults.standard.integer(forKey: "reminders") == 0 else { return }
            
            let content = self.createNotificationContent(from: hourBlock)
            let trigger = self.createNotificationTrigger(from: hourBlock)
            let request = UNNotificationRequest(identifier: hourBlock.id,
                                                content: content,
                                                trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { _ in }
        }
    }
    
    func removeReminder(for hourBlock: HourBlock) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [hourBlock.id])
    }
    
    private func hasPermissions(completion: @escaping (_ result: Bool) -> ()) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                completion(true)
            } else if settings.authorizationStatus == .notDetermined {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { result, error in
                    completion(result)
                }
            } else {
                completion(false)
            }
        }
    }
    
    private func createNotificationContent(from hourBlock: HourBlock) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "Upcoming Hour Block"
        content.body = "You have \(hourBlock.title!.lowercased()) coming up at \(hourBlock.hour.get12hTime())"
        content.sound = UNNotificationSound.init(named: UNNotificationSoundName("notification.aif"))
        
        return content
    }
    
    private func createNotificationTrigger(from hourBlock: HourBlock) -> UNNotificationTrigger {
        var date = Calendar.current.date(bySettingHour: hourBlock.hour, minute: 0, second: 0, of: hourBlock.day)!
        date = Calendar.current.date(byAdding: .minute, value: -10, to: date)!
        
        let triggerDate = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: date)
        return UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
    }
}
