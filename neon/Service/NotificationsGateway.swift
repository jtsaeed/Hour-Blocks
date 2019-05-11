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
    
	func addNotification(for agendaCard: AgendaCard, with timeOffset: Int, today: Bool, completion: @escaping (_ success: Bool) -> ()) {
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .notDetermined || settings.authorizationStatus == .denied {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound], completionHandler: { (result, error) in
                    if result == true {
						self.createNotification(for: agendaCard, with: timeOffset, today: today, completion: { (success) in
                            completion(success)
                        })
                    }
                })
            } else if settings.authorizationStatus == .authorized {
				self.createNotification(for: agendaCard, with: timeOffset, today: today, completion: { (success) in
                    completion(success)
                })
            } else {
                completion(false)
            }
        })
    }
    
    func removeNotification(for agendaCard: AgendaCard) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [agendaCard.agendaItem!.id])
    }
    
    func hasPendingNotification(for agendaCard: AgendaCard, completion: @escaping (_ result: Bool) -> ()) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            for request in requests {
                if request.identifier == agendaCard.agendaItem!.id {
                    completion(true)
                    return
                }
            }
            
            completion(false)
        }
    }
    
	private func createNotification(for agendaCard: AgendaCard, with timeOffset: Int, today: Bool, completion: @escaping (_ success: Bool) -> ()) {
        let content = UNMutableNotificationContent()
        content.title = "Upcoming Hour Block"
        content.body = "You have \(agendaCard.agendaItem!.title.lowercased()) coming up at \(agendaCard.hour.getFormattedHour())"
        content.sound = UNNotificationSound.init(named: UNNotificationSoundName("notification.aif"))
		
        var date = Calendar.current.date(bySettingHour: agendaCard.hour, minute: 0, second: 0, of: Date())!
		date = Calendar.current.date(byAdding: .minute, value: -timeOffset, to: date)!
		
        let dateTrigger = Calendar.current.dateComponents([.hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateTrigger, repeats: false)
        
        let request = UNNotificationRequest(identifier: agendaCard.agendaItem!.id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            completion(error == nil)
        }
    }
}
