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
    
	func addNotification(for block: HourBlock, with timeOffset: Int, today: Bool, completion: @escaping (_ success: Bool) -> ()) {
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .notDetermined || settings.authorizationStatus == .denied {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound], completionHandler: { (result, error) in
                    if result == true {
						self.createNotification(for: block, with: timeOffset, today: today, completion: { (success) in
                            completion(success)
                        })
                    }
                })
            } else if settings.authorizationStatus == .authorized {
				self.createNotification(for: block, with: timeOffset, today: today, completion: { (success) in
                    completion(success)
                })
            } else {
                completion(false)
            }
        })
    }
    
    func removeNotification(for block: HourBlock) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [block.identifier])
    }
    
    func hasPendingNotification(for block: HourBlock, completion: @escaping (_ result: Bool) -> ()) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            for request in requests {
                if request.identifier == block.identifier {
                    completion(true)
                    return
                }
            }
            
            completion(false)
        }
    }
    
	private func createNotification(for block: HourBlock, with timeOffset: Int, today: Bool, completion: @escaping (_ success: Bool) -> ()) {
        let content = UNMutableNotificationContent()
        content.title = "Upcoming Hour Block"
        content.body = "You have \(block.title!.lowercased()) coming up at \(block.hour.getFormattedHour())"
        content.sound = UNNotificationSound.init(named: UNNotificationSoundName("notification.aif"))
		
        var date = Calendar.current.date(bySettingHour: block.hour, minute: 0, second: 0, of: Date())!
		date = Calendar.current.date(byAdding: .minute, value: -timeOffset, to: date)!
		if !today { date = Calendar.current.date(byAdding: .day, value: 1, to: date)! }
        
        let dateTrigger = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateTrigger, repeats: false)
        
        let request = UNNotificationRequest(identifier: block.identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            completion(error == nil)
        }
    }
}
