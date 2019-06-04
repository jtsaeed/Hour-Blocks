//
//  ViewController.swift
//  neon
//
//  Created by James Saeed on 06/02/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import UIKit
import EventKit
import StoreKit
import WhatsNewKit
import UserNotifications
import Intents
import Toaster
import WatchConnectivity
import SwiftReorder

class ScheduleViewController: UITableViewController, Storyboarded {
	
	weak var coordinator: ScheduleCoordinator?
	
	var session: WCSession?
	
	var blocks = [Int: [Block]]() {
		didSet {
			blocks[Day.today.rawValue] = blocks[Day.today.rawValue]?.filter { $0.hour >= Calendar.current.component(.hour, from: Date()) }
			
			if !DataGateway.shared.getNightHours() {
				blocks[Day.tomorrow.rawValue] = blocks[Day.tomorrow.rawValue]?.filter({ $0.hour >= 6 })
			}
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialiseUI()
		setupWCSession()
		NotificationCenter.default.addObserver(self, selector: #selector(loadBlocks), name: Notification.Name("agendaUpdate"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadBlocks()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        CalendarGateway.shared.handlePermissions()
		if DataGateway.shared.hasAppBeenUpdated() { presentWhatsNew() }
    }
	
	@IBAction func swipedLeft(_ sender: Any) {
		coordinator?.swipeToSettings()
	}
}

// MARK: - Functionality

extension ScheduleViewController {
    
    @objc func loadBlocks() {
		self.blocks = DataGateway.shared.loadBlocks()
		DispatchQueue.main.async { self.tableView.reloadData() }
    }
    
    func addBlock(for indexPath: IndexPath, with title: String) {
		// Grab a reference to the Hour Block that we want to add to
		guard let block = blocks[indexPath.section]?[indexPath.row] else { return }
		
		// If there was already something here, get rid of it
		if let previousAgendaItem = block.agendaItem { DataGateway.shared.deleteBlock(previousAgendaItem) }
		
		// Initiate & save the new Hour Block and update the model
		let newAgendaItem = AgendaItem(title: title)
		DataGateway.shared.saveBlock(newAgendaItem, for: block.hour,
								today: indexPath.section == Day.today.rawValue)
		blocks[indexPath.section]?[indexPath.row].agendaItem = newAgendaItem

		// Finishing tasks
		AnalyticsGateway.shared.logHourBlock(for: title)
		copyToWatch(data: blocks[Day.today.rawValue] ?? [Block]())
        tableView.reloadRows(at: [indexPath], with: .fade)
        handleReviewRequest()
    }
    
    func removeBlock(for indexPath: IndexPath) {
		// Grab a reference to the Hour Block's agenda item that we want to remove
		guard let block = blocks[indexPath.section]?[indexPath.row] else { return }
		
		// Delete and update the model
		DataGateway.shared.deleteBlock(block.agendaItem!)
		NotificationsGateway.shared.removeNotification(for: block)
		blocks[indexPath.section]?[indexPath.row].agendaItem = nil
		
		// Finishing tasks
		copyToWatch(data: blocks[Day.today.rawValue] ?? [Block]())
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    func isCalendarEvent(at indexPath: IndexPath) -> Bool {
		// Return false if we can't grab an instance of the agenda item in question
		guard let currentAgendaItem = blocks[indexPath.section]?[indexPath.row].agendaItem else { return false }
		
		// Return if the referenced agenda item icon is a calendar
		return currentAgendaItem.icon == "calendar"
    }
    
    func hasReminderSet(at indexPath: IndexPath, completion: @escaping (_ result: Bool) -> ()) {
		if let block = blocks[indexPath.section]?[indexPath.row] {
			NotificationsGateway.shared.hasPendingNotification(for: block) { (result) in
				completion(result)
			}
		} else {
			completion(false)
		}
    }
    
	func addReminder(for indexPath: IndexPath, timeOffset: Int, today: Bool) {
		guard let block = blocks[indexPath.section]?[indexPath.row] else { return }
		
		NotificationsGateway.shared.addNotification(for: block, with: timeOffset, today: today, completion: { (success) in
			if success {
				AnalyticsGateway.shared.logReminder(for: timeOffset)
				DispatchQueue.main.async { UINotificationFeedbackGenerator().notificationOccurred(.success) }
			} else {
				DispatchQueue.main.async { UINotificationFeedbackGenerator().notificationOccurred(.error) }
			}
		})
    }
    
    func removeReminder(for indexPath: IndexPath) {
		if let block = blocks[indexPath.section]?[indexPath.row] {
			NotificationsGateway.shared.removeNotification(for: block)
			UINotificationFeedbackGenerator().notificationOccurred(.success)
		}
    }
    
    func handleReviewRequest() {
        let count = DataGateway.shared.getTotalAgendaCount()
        
        if count == 10 || count == 25 || count == 50 { SKStoreReviewController.requestReview() }
    }
}

// MARK: - Table View

extension ScheduleViewController: TableViewReorderDelegate {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 112
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionHeader = Bundle.main.loadNibNamed("SectionHeaderView", owner: self, options: nil)?.first as? SectionHeaderView else { return UIView() }
        sectionHeader.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 112)
        
        if section == Day.today.rawValue {
            sectionHeader.build(for: .today)
        } else if section == Day.tomorrow.rawValue {
            sectionHeader.build(for: .tomorrow)
        }
        
        return sectionHeader
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return blocks[section]?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let block = blocks[indexPath.section]?[indexPath.row] else { return }
		
		if block.hour < Calendar.current.component(.hour, from: Date()) && indexPath.section == Day.today.rawValue {
			tableView.reloadData()
			return
		}
		
		if !block.isEmpty { showAgendaOptionsDialog(for: block, at: indexPath) }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let spacer = tableView.reorder.spacerCell(for: indexPath) { return spacer }
		
		guard let block = blocks[indexPath.section]?[indexPath.row] else { return UITableViewCell() }
		
		if let agendaItem = block.agendaItem {
			return buildAgendaCell(with: agendaItem, for: block.hour)
		} else {
			return buildEmptyCell(for: block.hour, at: indexPath)
		}
    }
	
	func tableView(_ tableView: UITableView, reorderRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) { }
	
	func tableView(_ tableView: UITableView, canReorderRowAt indexPath: IndexPath) -> Bool {
		guard let block = blocks[indexPath.section]?[indexPath.row] else { return false }
		
		return block.agendaItem != nil
	}
	
	func tableViewDidBeginReordering(_ tableView: UITableView, at indexPath: IndexPath) {
		UIImpactFeedbackGenerator(style: .medium).impactOccurred()
	}
	
	func tableViewDidFinishReordering(_ tableView: UITableView, from initialSourceIndexPath: IndexPath, to finalDestinationIndexPath: IndexPath) {
		guard let sourceBlock = blocks[initialSourceIndexPath.section]?[initialSourceIndexPath.row] else { return }
		guard let destinationBlock = blocks[finalDestinationIndexPath.section]?[finalDestinationIndexPath.row] else { return }
		
		if let agendaItem = sourceBlock.agendaItem {
			DataGateway.shared.deleteBlock(agendaItem)
			blocks[initialSourceIndexPath.section]?[initialSourceIndexPath.row].agendaItem = nil
			
			blocks[finalDestinationIndexPath.section]?[finalDestinationIndexPath.row].agendaItem = agendaItem
			DataGateway.shared.saveBlock(agendaItem, for: destinationBlock.hour, today: initialSourceIndexPath.section == Day.today.rawValue)
		}
		
		UINotificationFeedbackGenerator().notificationOccurred(.success)
		tableView.reloadData()
	}
	
	func tableView(_ tableView: UITableView, targetIndexPathForReorderFromRowAt sourceIndexPath: IndexPath, to proposedDestinationIndexPath: IndexPath) -> IndexPath {
		if sourceIndexPath.section == Day.today.rawValue &&
			proposedDestinationIndexPath.section == Day.tomorrow.rawValue {
			let lastRowOfToday = tableView.numberOfRows(inSection: Day.today.rawValue) - 1
			return IndexPath(row: lastRowOfToday, section: Day.today.rawValue)
		} else if sourceIndexPath.section == Day.tomorrow.rawValue &&
			proposedDestinationIndexPath.section == Day.today.rawValue {
			return IndexPath(row: 0, section: Day.tomorrow.rawValue)
		} else {
			return proposedDestinationIndexPath
		}
	}
    
    func buildAgendaCell(with agendaItem: AgendaItem, for hour: Int) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "hourBlockCell") as? HourBlockCell else { return UITableViewCell() }
        cell.build(with: agendaItem, for: hour)
        return cell
    }
    
    func buildEmptyCell(for hour: Int, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "emptyBlockCell") as? EmptyBlockCell else { return UITableViewCell() }
        cell.build(for: hour, at: indexPath)
        cell.delegate = self
        return cell
    }
}

// MARK: - Dialogs

extension ScheduleViewController: AddAgendaDelegate, AddAgendaAlertViewDelegate {
    
    func showAddAgendaDialog(for block: Block?, at indexPath: IndexPath) {
        let alert = self.storyboard?.instantiateViewController(withIdentifier: "AddAgendaAlert") as! AddAgendAlertViewController
        alert.providesPresentationContextTransitionStyle = true
        alert.definesPresentationContext = true
        alert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        alert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        alert.delegate = self
        alert.indexPath = indexPath
        alert.preFilledTitle = block?.agendaItem?.title
		// TODO: Unwrap this safely
		alert.time = blocks[indexPath.section]![indexPath.row].hour.getFormattedHour().lowercased()
        
        setStatusBarBackground(as: .clear)
        present(alert, animated: true, completion: nil)
    }
	
	func addPredictedBlock(title: String, indexPath: IndexPath) {
		addBlock(for: indexPath, with: title)
	}
    
    func doneButtonTapped(textFieldValue: String, indexPath: IndexPath) {
        addBlock(for: indexPath, with: textFieldValue)
        setStatusBarBackground(as: .white)
    }
    
    func cancelButtonTapped() {
        setStatusBarBackground(as: .white)
    }
    
    func showAgendaOptionsDialog(for block: Block, at indexPath: IndexPath) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: AppStrings.Schedule.edit, style: .default, handler: { action in
            self.showAddAgendaDialog(for: block, at: indexPath)
        }))
        if (!isCalendarEvent(at: indexPath)) {
            actionSheet.addAction(UIAlertAction(title: AppStrings.Schedule.clear, style: .destructive, handler: { action in
                self.removeBlock(for: indexPath)
                self.setStatusBarBackground(as: .white)
            }))
			
//			if indexPath.section == Day.today.rawValue {
            	hasReminderSet(at: indexPath) { (result) in
                	if result == true {
                    	actionSheet.addAction(UIAlertAction(title: AppStrings.Schedule.removeReminder, style: .destructive, handler: { action in
                	        self.removeReminder(for: indexPath)
                    	    self.setStatusBarBackground(as: .white)
                    	}))
                	} else {
                    	actionSheet.addAction(UIAlertAction(title: AppStrings.Schedule.setReminder, style: .default, handler: { action in
							self.showReminderOptionsDialog(for: indexPath, today: indexPath.section == Day.today.rawValue)
                    	}))
                	}
            	}
//			}
        }
        actionSheet.addAction(UIAlertAction(title: AppStrings.cancel, style: .cancel, handler: { action in
            self.setStatusBarBackground(as: .white)
        }))
        
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        setStatusBarBackground(as: .clear)
        present(actionSheet, animated: true, completion: nil)
    }
    
	func showReminderOptionsDialog(for indexPath: IndexPath, today: Bool) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: String(format: AppStrings.Schedule.timeBeforeReminder, 60), style: .default, handler: { action in
			self.addReminder(for: indexPath, timeOffset: 60, today: today)
            self.setStatusBarBackground(as: .white)
        }))
        actionSheet.addAction(UIAlertAction(title: String(format: AppStrings.Schedule.timeBeforeReminder, 30), style: .default, handler: { action in
            self.addReminder(for: indexPath, timeOffset: 30, today: today)
            self.setStatusBarBackground(as: .white)
        }))
        actionSheet.addAction(UIAlertAction(title: String(format: AppStrings.Schedule.timeBeforeReminder, 15), style: .default, handler: { action in
            self.addReminder(for: indexPath, timeOffset: 15, today: today)
            self.setStatusBarBackground(as: .white)
        }))
        actionSheet.addAction(UIAlertAction(title: String(format: AppStrings.Schedule.timeBeforeReminder, 5), style: .default, handler: { action in
            self.addReminder(for: indexPath, timeOffset: 5, today: today)
            self.setStatusBarBackground(as: .white)
        }))
        actionSheet.addAction(UIAlertAction(title: AppStrings.cancel, style: .cancel, handler: { action in
            self.setStatusBarBackground(as: .white)
        }))
        
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        setStatusBarBackground(as: .clear)
        present(actionSheet, animated: true, completion: nil)
    }
}

// MARK: - UI

extension ScheduleViewController {
    
    func initialiseUI() {
        setupTableView()
        setStatusBarBackground(as: .white)
    }
    
    func setupTableView() {
        tableView.frame = .zero
		tableView.reorder.delegate = self
		tableView.reorder.cellScale = 1.05
		tableView.reorder.shadowOpacity = 0
		tableView.reorder.shadowRadius = 0
    }
    
    func setStatusBarBackground(as color: UIColor) {
        guard let statusBarView = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else {
            return
        }
        UIView.animate(withDuration: 0.15) {
            statusBarView.backgroundColor = color
        }
    }
    
    func presentWhatsNew() {
        let whatsNew = WhatsNew(
            title: "What's New in Version 1.3.1",
            items: [
				WhatsNew.Item(
					title: "Minor Improvements & Fixes",
					subtitle: "Reminders can now be set for tomorrow, the empty 'about' section is gone, the night time hours toggle now works during those hours and many more 🐞",
					image: nil
				)
            ]
        )
        var configuration = WhatsNewViewController.Configuration()
        configuration.completionButton.backgroundColor = UIColor(named: "main")!
        configuration.completionButton.title = "Let's go!"
        configuration.completionButton.hapticFeedback = .impact(.light)
        let whatsNewVC = WhatsNewViewController(whatsNew: whatsNew, configuration: configuration)
        
        self.present(whatsNewVC, animated: true, completion: nil)
    }
}

// MARK: - Watch

extension ScheduleViewController: WCSessionDelegate {
	
	func copyToWatch(data blocks: [Block]) {
		var watchAgendaItems = [Int: String]()
		
		for hour in 0...23 { watchAgendaItems[hour] = "Empty" }
		for block in blocks { watchAgendaItems[block.hour] = block.agendaItem?.title }
		
		if let validSession = session {
			let phoneAppContext = ["todaysAgendaItems": watchAgendaItems]
			
			do {
				try validSession.updateApplicationContext(phoneAppContext)
			} catch _  { }
		}
	}
	
	func setupWCSession() {
		if WCSession.isSupported() {
			session = WCSession.default
			session?.delegate = self
			session?.activate()
		}
	}
	
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) { }
	func sessionDidBecomeInactive(_ session: WCSession) { }
	func sessionDidDeactivate(_ session: WCSession) { }
}
