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
	
	func setMorningNotification(on: Bool) {
		
	}
	
	private func createMorningNotification(completion: @escaping (_ success: Bool) -> ()) {
		let content = UNMutableNotificationContent()
		content.title = "Good morning! 😁"
		content.body = "Here's your daily reminder to organise your day ☀️"
		content.sound = UNNotificationSound.init(named: UNNotificationSoundName("notification.aif"))
		
		let date = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date())!
		
		let dateTrigger = Calendar.current.dateComponents([.hour, .minute, .second], from: date)
		let trigger = UNCalendarNotificationTrigger(dateMatching: dateTrigger, repeats: true)
		
		let request = UNNotificationRequest(identifier: "morningNotification", content: content, trigger: trigger)
		
		UNUserNotificationCenter.current().add(request) { error in
			completion(error == nil)
		}
	}
	
	private func removeMorningNotification() {
		UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["morningNotification"])
	}
    
	func addNotification(for block: Block, with timeOffset: Int, today: Bool, completion: @escaping (_ success: Bool) -> ()) {
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
    
    func removeNotification(for block: Block) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [block.agendaItem!.id])
    }
    
    func hasPendingNotification(for block: Block, completion: @escaping (_ result: Bool) -> ()) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            for request in requests {
                if request.identifier == block.agendaItem!.id {
                    completion(true)
                    return
                }
            }
            
            completion(false)
        }
    }
    
	private func createNotification(for block: Block, with timeOffset: Int, today: Bool, completion: @escaping (_ success: Bool) -> ()) {
        let content = UNMutableNotificationContent()
        content.title = "Upcoming Hour Block"
        content.body = "You have \(block.agendaItem!.title.lowercased()) coming up at \(block.hour.getFormattedHour())"
        content.sound = UNNotificationSound.init(named: UNNotificationSoundName("notification.aif"))
		
        var date = Calendar.current.date(bySettingHour: block.hour, minute: 0, second: 0, of: Date())!
		date = Calendar.current.date(byAdding: .minute, value: -timeOffset, to: date)!
		
		if !today { date = Calendar.current.date(byAdding: .day, value: 1, to: date)! }
		
        let dateTrigger = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateTrigger, repeats: false)
        
        let request = UNNotificationRequest(identifier: block.agendaItem!.id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            completion(error == nil)
        }
    }
}
