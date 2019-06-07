//
//  AppCoordinator.swift
//  neon
//
//  Created by James Saeed on 19/05/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import UIKit
import Hero

class AppCoordinator: Coordinator {
	
	var navigationController: UINavigationController
	var tabBarController: UITabBarController
	
	var toDoCoordinator: ToDoCoordinator
	var scheduleCoordinator: ScheduleCoordinator
	var settingsCoordinator: SettingsCoordinator
	
	init() {
		// Construct nav bar
		self.navigationController = UINavigationController()
		self.tabBarController = UITabBarController()
		self.tabBarController.tabBar.backgroundColor = UIColor(named: "mainLight")
		self.tabBarController.tabBar.tintColor = UIColor(named: "main")
		self.tabBarController.hero.isEnabled = true
		self.tabBarController.hero.modalAnimationTypeString = "swipe"
		
		// Initialise schedule tab
		self.toDoCoordinator = ToDoCoordinator()
		let toDoViewController = toDoCoordinator.navigationController
		toDoViewController.tabBarItem = UITabBarItem(title: "To Do List", image: UIImage(named: "list"), tag: 0)
		
		// Initialise schedule tab
		self.scheduleCoordinator = ScheduleCoordinator()
		let scheduleViewController = scheduleCoordinator.navigationController
		scheduleViewController.tabBarItem = UITabBarItem(title: AppStrings.Schedule.tab, image: UIImage(named: "schedule"), tag: 0)
		
		// Initialise settings tab
		self.settingsCoordinator = SettingsCoordinator()
		let settingsViewController = settingsCoordinator.navigationController
		settingsViewController.tabBarItem = UITabBarItem(title: AppStrings.Settings.tab, image: UIImage(named: "settings"), tag: 1)
		
		// Add app level coordinator to child coordinators
		self.toDoCoordinator.appCoordinator = self
		self.scheduleCoordinator.appCoordinator = self
		self.settingsCoordinator.appCoordinator = self
		
		// Construct the tab bar
		self.tabBarController.viewControllers = [scheduleViewController, settingsViewController]
		self.tabBarController.selectedIndex = 0
	}
	
	func swipeToToDo() {
		self.tabBarController.selectedIndex = 0
	}
	
	func swipeToSchedule() {
		self.tabBarController.selectedIndex = 0
	}
	
	func swipeToSettings() {
		self.tabBarController.selectedIndex = 1
	}
}
