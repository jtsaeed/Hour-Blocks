//
//  TestGateway.swift
//  neon
//
//  Created by James Saeed on 25/03/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import Foundation
import CoreData

class DataGateway {
	
    static let shared = DataGateway()
	
	lazy var persistentContainer: NSPersistentContainer = {
		let container = NSHourBlocksPersistentContainer(name: "neon")
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}()
	
	func saveContext() {
		let context = persistentContainer.viewContext
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				print("Error saving")
			}
		}
	}
}

// MARK: - Blocks

extension DataGateway {
	
	func loadBlocks() -> [Int: [Block]] {
		// Initialise the blocks data structure
		var blocks = [Int: [Block]]()
		blocks[Day.today.rawValue] = [Block]()
		blocks[Day.tomorrow.rawValue] = [Block]()
		
		// Initialise the agenda items data structure that will be fed into the blocks
		var todayAgendaItems = [Int: AgendaItem]()
		var tomorrowAgendaItems = [Int: AgendaItem]()
		
		// Pull all the calendar events
		if CalendarGateway.shared.hasPermission() {
			for event in CalendarGateway.shared.importTodaysEvents() {
				for i in event.startTime...event.endTime {
					var agendaItem = AgendaItem(title: event.title)
					agendaItem.icon = "calendar"
					todayAgendaItems[i] = agendaItem
				}
			}
			
			for event in CalendarGateway.shared.importTomorrowsEvents() {
				for i in event.startTime...event.endTime {
					var agendaItem = AgendaItem(title: event.title)
					agendaItem.icon = "calendar"
					tomorrowAgendaItems[i] = agendaItem
				}
			}
		}
		
		// Pull all the agenda items from Core Data
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AgendaEntity")
		request.returnsObjectsAsFaults = false
		do {
			let result = try persistentContainer.viewContext.fetch(request)
			for data in result as! [NSManagedObject] {
				guard let day = data.value(forKey: "day") as? Date else { continue }
				guard let hour = data.value(forKey: "hour") as? Int else { continue }
				guard let title = data.value(forKey: "title") as? String else { continue }
				guard let id = data.value(forKey: "id") as? String else { continue }
				
				// Only pull the agenda items that are in today/tomorrow, delete any others
				if Calendar.current.isDateInToday(day) {
					todayAgendaItems[hour] = AgendaItem(with: id, and: title)
				} else if Calendar.current.isDateInTomorrow(day) {
					tomorrowAgendaItems[hour] = AgendaItem(with: id, and: title)
				} else {
					persistentContainer.viewContext.delete(data)
				}
			}
		} catch {
			print("Failed loading from Core Data")
		}
		
		// Generate blocks from agenda items
		for hour in 0...23 {
			blocks[Day.today.rawValue]?.append(Block(hour: hour, agendaItem: todayAgendaItems[hour]))
			blocks[Day.tomorrow.rawValue]?.append(Block(hour: hour, agendaItem: tomorrowAgendaItems[hour]))
		}
		
		return blocks
	}
	
	func save(_ agendaItem: AgendaItem, for hour: Int, today: Bool) {
		let entity = NSEntityDescription.entity(forEntityName: "AgendaEntity", in: persistentContainer.viewContext)
		let newAgendaItem = NSManagedObject(entity: entity!, insertInto: persistentContainer.viewContext)
		
		newAgendaItem.setValue(today ? Date() : Calendar.current.date(byAdding: .day, value: 1, to: Date())!, forKey: "day")
		newAgendaItem.setValue(hour, forKey: "hour")
		newAgendaItem.setValue(agendaItem.title, forKey: "title")
		newAgendaItem.setValue(agendaItem.id, forKey: "id")
		
		saveContext()
	}
	
	func delete(_ agendaItem: AgendaItem) {
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AgendaEntity")
		request.predicate = NSPredicate(format: "id = %@", agendaItem.id)
		
		do {
			let result = try persistentContainer.viewContext.fetch(request)
			for data in result as! [NSManagedObject] {
				persistentContainer.viewContext.delete(data)
				saveContext()
			}
		} catch {
			print("Failed loading")
		}
	}
}

// MARK: - Misc

extension DataGateway {
	
	func hasAppBeenUpdated() -> Bool {
		let currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
		let versionOfLastRun = UserDefaults.standard.object(forKey: "VersionOfLastRun") as? String
		
		UserDefaults.standard.set(currentVersion, forKey: "VersionOfLastRun")
		UserDefaults.standard.synchronize()
		
		return versionOfLastRun != nil && versionOfLastRun != currentVersion
	}
	
	func getTotalAgendaCount() -> Int {
		guard let totalAgendaCount = UserDefaults.standard.object(forKey: "totalAgendaCount") as? Int else {
			return 0
		}
		return totalAgendaCount
	}
	
	private func incrementTotalAgendaCount() {
		let totalAgendaCount = UserDefaults.standard.object(forKey: "totalAgendaCount") as? Int
		
		if totalAgendaCount == nil {
			UserDefaults.standard.set(1, forKey: "totalAgendaCount")
		} else {
			UserDefaults.standard.set(totalAgendaCount! + 1, forKey: "totalAgendaCount")
		}
		
		UserDefaults.standard.synchronize()
	}
	
	func saveEnabledCalendars(_ calendars: [String: Bool]) {
		UserDefaults.standard.set(calendars, forKey: "enabledCalendars")
		UserDefaults.standard.synchronize()
	}
	
	func loadEnabledCalendars() -> [String: Bool]? {
		return UserDefaults.standard.dictionary(forKey: "enabledCalendars") as? [String: Bool]
	}
}

// MARK: - Custom Persistent Container
class NSHourBlocksPersistentContainer: NSPersistentContainer {
	
	override open class func defaultDirectoryURL() -> URL {
		var storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.evh98.neon")
		storeURL = storeURL?.appendingPathComponent("neon.sqlite")
		return storeURL!
	}
}
