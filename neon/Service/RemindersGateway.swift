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

/// The gateway service used to interface with EventKit.
struct RemindersGateway: RemindersGatewayProtocol {
    
    /// Sets a reminder in notification center for a given Hour Block.
    ///
    /// - Parameters:
    ///   - hourBlock: The Hour Block to be reminded about.
    ///   - title: The formatted title of the notification.
    func setReminder(for hourBlock: HourBlock, with title: String) {
        handlePermissions { result in
            // Return if notification permissions haven't been granted, or reminders have been disabled
            guard result == true else { return }
            guard UserDefaults.standard.integer(forKey: "reminders") == 0 else { return }
            
            let content = createNotificationContent(from: hourBlock, with: title)
            let trigger = createNotificationTrigger(from: hourBlock)
            let request = UNNotificationRequest(identifier: hourBlock.id,
                                                content: content,
                                                trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { _ in }
        }
    }
    
    /// Removes a reminder from notification center for a given Hour Block.
    ///
    /// - Parameters:
    ///   - hourBlock: The Hour Block to remove the reminder for.
    func removeReminder(for hourBlock: HourBlock) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [hourBlock.id])
    }
    
    /// Edits a reminder in notification center for a given Hour Block; called when an Hour Block's title is edited.
    ///
    /// - Parameters:
    ///   - hourBlock: The Hour Block to edit the reminder for.
    ///   - title: The updated formatted title of the notification.
    func editReminder(for hourBlock: HourBlock, with title: String) {
        removeReminder(for: hourBlock)
        setReminder(for: hourBlock, with: title)
    }
}

// MARK: - Private Functionality

extension RemindersGateway {
    
    /// Request reminders permissions from the user, then set the reminders settings accordingly.
    ///
    /// - Parameters:
    ///   - completion: The callback function to be triggered when the user has chosen to grant access, providing a value on whether or not permission was granted.
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
    
    /// Creates the notification content for a given Hour Block.
    ///
    /// - Parameters:
    ///   - hourBlock: The Hour Block to create a notification for.
    ///   - title: The formatted title of the notification.
    ///
    /// - Returns:
    /// A notification content instance.
    private func createNotificationContent(from hourBlock: HourBlock, with title: String) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = title.smartCapitalization()
        content.body = "Coming up at \(hourBlock.hour.get12hTime().lowercased())"
        content.sound = UNNotificationSound.init(named: UNNotificationSoundName("notification.aif"))
        
        return content
    }
    
    /// Creates the notification trigger for a given Hour Block.
    ///
    /// - Parameters:
    ///   - hourBlock: The Hour Block to create a trigger for.
    ///
    /// - Returns:
    /// A notification trigger instance.
    private func createNotificationTrigger(from hourBlock: HourBlock) -> UNNotificationTrigger {
        var date = Calendar.current.date(bySettingHour: hourBlock.hour, minute: 0, second: 0, of: hourBlock.day)!
        date = Calendar.current.date(byAdding: .minute, value: -15, to: date)!
        
        let triggerDate = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: date)
        return UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
    }
}
