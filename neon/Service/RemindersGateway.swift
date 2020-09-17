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
    
    func setReminder(for hourBlock: HourBlock, with title: String)
    func removeReminder(for hourBlock: HourBlock)
    func editReminder(for hourBlock: HourBlock, with title: String)
}

struct RemindersGateway: RemindersGatewayProtocol {
    
    func setReminder(for hourBlock: HourBlock, with title: String) {
        handlePermissions { result in
            guard result == true else { return }
            guard UserDefaults.standard.integer(forKey: "reminders") == 0 else { return }
            
            let content = self.createNotificationContent(from: hourBlock, with: title)
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

    func editReminder(for hourBlock: HourBlock, with title: String) {
        removeReminder(for: hourBlock)
        setReminder(for: hourBlock, with: title)
    }
    
    private func handlePermissions(completion: @escaping (_ result: Bool) -> ()) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                completion(true)
            } else if settings.authorizationStatus == .notDetermined {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { result, error in
                    if !result { UserDefaults.standard.set(1, forKey: "reminders") }
                    completion(result)
                    return
                }
                
                completion(false)
            } else {
                UserDefaults.standard.set(1, forKey: "reminders")
                completion(false)
            }
        }
    }
    
    private func createNotificationContent(from hourBlock: HourBlock, with title: String) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = title.smartCapitalization()
        content.body = "Coming up at \(hourBlock.hour.get12hTime().lowercased())"
        content.sound = UNNotificationSound.init(named: UNNotificationSoundName("notification.aif"))
        
        return content
    }
    
    private func createNotificationTrigger(from hourBlock: HourBlock) -> UNNotificationTrigger {
        var date = Calendar.current.date(bySettingHour: hourBlock.hour, minute: 0, second: 0, of: hourBlock.day)!
        date = Calendar.current.date(byAdding: .minute, value: -15, to: date)!
        
        let triggerDate = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: date)
        return UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
    }
}
