//
//  NotificationGateway.swift
//  neon
//
//  Created by James Saeed on 27/03/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationsGateway {
    
    static let shared = NotificationsGateway()
    
    func addNotification(for block: HourBlock, on date: Date, completion: @escaping (_ success: Bool) -> ()) {
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .notDetermined || settings.authorizationStatus == .denied {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound], completionHandler: { (result, error) in
                    if result == true {
                        self.createNotification(for: block, on: date, completion: { (success) in
                            completion(success)
                        })
                    }
                })
            } else if settings.authorizationStatus == .authorized {
                self.createNotification(for: block, on: date, completion: { (success) in
                    completion(success)
                })
            } else {
                completion(false)
            }
        })
    }
    
    func removeNotification(for block: HourBlock) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [block.id])
    }
    
    func hasPendingNotification(for block: HourBlock, completion: @escaping (_ result: Bool) -> ()) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            for request in requests {
                if request.identifier == block.id {
                    completion(true)
                    return
                }
            }
            
            completion(false)
        }
    }
    
    private func createNotification(for block: HourBlock, on date: Date, completion: @escaping (Bool) -> ()) {
        let content = UNMutableNotificationContent()
        content.title = "Upcoming Hour Block"
        content.body = "You have \(block.title!.lowercased()) coming up at \(block.hour.get12hTime())"
        #if os(iOS)
        content.sound = UNNotificationSound.init(named: UNNotificationSoundName("notification.aif"))
        #endif
        
        let timeOffset = 10
        
        /*
        if let timeSetting = DataGateway.shared.getOtherSettings()?.reminderTimer {
            if timeSetting == 0 {
                timeOffset = 15
            } else if timeSetting == 2 {
                timeOffset = 5
            }
        }
         */
		
        var date = Calendar.current.date(bySettingHour: block.hour, minute: 0, second: 0, of: date)!
		date = Calendar.current.date(byAdding: .minute, value: -timeOffset, to: date)!
        
        let dateTrigger = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateTrigger, repeats: false)
        
        let request = UNNotificationRequest(identifier: block.id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            completion(error == nil)
        }
    }
}
