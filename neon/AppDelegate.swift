//
//  AppDelegate.swift
//  neon
//
//  Created by James Saeed on 06/02/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
	var coordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
        FirebaseApp.configure()
		coordinatorConfiguration()
		
        return true
    }
	
	func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
		guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return false }
		
		if components.path != "" {
			if let title = components.path.removingPercentEncoding?.replacingOccurrences(of: "/", with: "") {
				DataGateway.shared.save(AgendaItem(title: title), for: 19, today: true)
				NotificationCenter.default.post(name: Notification.Name("agendaUpdate"), object: nil)
				return true
			}
		}
		
		return false
	}
	
	func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
		guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
			let url = userActivity.webpageURL,
			var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
				return false
		}
		
		if components.path != "" {
			if let title = components.path.removingPercentEncoding?.replacingOccurrences(of: "/", with: "") {
				DataGateway.shared.save(AgendaItem(title: title), for: 19, today: true)
				NotificationCenter.default.post(name: Notification.Name("agendaUpdate"), object: nil)
				return true
			}
		}
		
		return false
	}
	
	private func coordinatorConfiguration() {
		coordinator = AppCoordinator()
		self.window = UIWindow(frame: UIScreen.main.bounds)
		self.window?.rootViewController = coordinator?.tabBarController
		self.window?.makeKeyAndVisible()
	}

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        NotificationCenter.default.post(name: Notification.Name("agendaUpdate"), object: nil)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

