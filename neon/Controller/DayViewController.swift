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

class DayViewController: UITableViewController {
	
	var session: WCSession?
	
	var blocks = [Int: [Block]]() {
		didSet {
			blocks[Day.today.rawValue] = blocks[Day.today.rawValue]?.filter { $0.hour >= Calendar.current.component(.hour, from: Date()) }
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialiseUI()
		setupWCSession()
        NotificationCenter.default.addObserver(self, selector: #selector(loadAgendaItems), name: Notification.Name("agendaUpdate"), object: nil)
        DataGateway.shared.deletePastAgendaRecords()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadAgendaItems()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        CalendarGateway.shared.handlePermissions()
        checkAppUpgrade()
    }
    
    @IBAction func pulledToRefresh(_ sender: UIRefreshControl) {
        DataGateway.shared.fetchAgendaItems { (todaysAgendaItems, tomorrowsAgendaItems, success) in
            if success {
                self.generateCards(from: todaysAgendaItems, and: tomorrowsAgendaItems)
                DispatchQueue.main.async { sender.endRefreshing() }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.tableView.reloadData()
                })
            } else {
                self.showConnectionToast()
                DispatchQueue.main.async { sender.endRefreshing() }
            }
        }
    }
}

// MARK: - Functionality

extension DayViewController {
    
    @objc func loadAgendaItems() {
        DataGateway.shared.fetchAgendaItems { (todaysAgendaItems, tomorrowsAgendaItems, success) in
            if success {
                self.generateCards(from: todaysAgendaItems, and: tomorrowsAgendaItems)
                DispatchQueue.main.async { self.tableView.reloadData() }
            } else {
                self.showConnectionToast()
            }
        }
    }
    
    func generateCards(from todayAgendaItems: [Int: AgendaItem], and tomorrowAgendaItems: [Int: AgendaItem]) {
		blocks[Day.today.rawValue] = [Block]()
		blocks[Day.tomorrow.rawValue] = [Block]()
        for hour in 0...23 {
            blocks[Day.today.rawValue]?.append(Block(hour: hour, agendaItem: todayAgendaItems[hour]))
            blocks[Day.tomorrow.rawValue]?.append(Block(hour: hour, agendaItem: tomorrowAgendaItems[hour]))
        }
		
		copyToWatch(data: blocks[Day.today.rawValue] ?? [Block]())
    }
    
    func addBlock(for indexPath: IndexPath, with title: String) {
		// Grab a reference to the Hour Block that we want to add to
		guard let block = blocks[indexPath.section]?[indexPath.row] else { return }
		
		// If there was already something here, get rid of it
		if let previousAgendaItem = block.agendaItem { DataGateway.shared.delete(previousAgendaItem) }
		
		// Initiate & save the new Hour Block and update the model
		let newAgendaItem = AgendaItem(title: title)
		DataGateway.shared.save(newAgendaItem, for: block.hour,
								today: indexPath.section == Day.today.rawValue)
		blocks[indexPath.section]?[indexPath.row].agendaItem = newAgendaItem
		if #available(iOS 12.0, *) { donateInteraction(for: block) }

		// Finishing tasks
		AnalyticsGateway.shared.logNewHourBlock(for: newAgendaItem.title, and: newAgendaItem.icon)
		copyToWatch(data: blocks[Day.today.rawValue] ?? [Block]())
        tableView.reloadRows(at: [indexPath], with: .fade)
        handleReviewRequest()
    }
    
    func removeBlock(for indexPath: IndexPath) {
		// Grab a reference to the Hour Block's agenda item that we want to remove
		guard let block = blocks[indexPath.section]?[indexPath.row] else { return }
		
		// Delete and update the model
		DataGateway.shared.delete(block.agendaItem!)
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
    
    func addReminder(for indexPath: IndexPath, timeOffset: Int) {
		guard let block = blocks[indexPath.section]?[indexPath.row] else { return }
		
		NotificationsGateway.shared.addNotification(for: block, with: timeOffset, today: true, completion: { (success) in
			if success {
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
    
    @available(iOS 12.0, *)
    func donateInteraction(for block: Block) {
        let interaction = INInteraction(intent: block.intent, response: nil)
        interaction.donate { error in }
    }
}

// MARK: - Table View

extension DayViewController: TableViewReorderDelegate {
    
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
			DataGateway.shared.delete(agendaItem)
			blocks[initialSourceIndexPath.section]?[initialSourceIndexPath.row].agendaItem = nil
			
			blocks[finalDestinationIndexPath.section]?[finalDestinationIndexPath.row].agendaItem = agendaItem
			DataGateway.shared.save(agendaItem, for: destinationBlock.hour, today: initialSourceIndexPath.section == Day.today.rawValue)
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

extension DayViewController: AddAgendaDelegate, AddAgendaAlertViewDelegate {
    
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
    
    func doneButtonTapped(textFieldValue: String, indexPath: IndexPath) {
        addBlock(for: indexPath, with: textFieldValue)
        setStatusBarBackground(as: .white)
    }
    
    func cancelButtonTapped() {
        setStatusBarBackground(as: .white)
    }
    
    func showAgendaOptionsDialog(for block: Block, at indexPath: IndexPath) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { action in
            self.showAddAgendaDialog(for: block, at: indexPath)
        }))
        if (!isCalendarEvent(at: indexPath)) {
            actionSheet.addAction(UIAlertAction(title: "Clear", style: .destructive, handler: { action in
                self.removeBlock(for: indexPath)
                self.setStatusBarBackground(as: .white)
            }))
			
			if indexPath.section == Day.today.rawValue {
            	hasReminderSet(at: indexPath) { (result) in
                	if result == true {
                    	actionSheet.addAction(UIAlertAction(title: "Remove Reminder", style: .destructive, handler: { action in
                	        self.removeReminder(for: indexPath)
                    	    self.setStatusBarBackground(as: .white)
                    	}))
                	} else {
                    	actionSheet.addAction(UIAlertAction(title: "Set Reminder", style: .default, handler: { action in
                        	self.showReminderOptionsDialog(for: indexPath)
                    	}))
                	}
            	}
			}
        }
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
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
    
    func showReminderOptionsDialog(for indexPath: IndexPath) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "60 minutes before", style: .default, handler: { action in
            self.addReminder(for: indexPath, timeOffset: 60)
            self.setStatusBarBackground(as: .white)
        }))
        actionSheet.addAction(UIAlertAction(title: "30 minutes before", style: .default, handler: { action in
            self.addReminder(for: indexPath, timeOffset: 30)
            self.setStatusBarBackground(as: .white)
        }))
        actionSheet.addAction(UIAlertAction(title: "15 minutes before", style: .default, handler: { action in
            self.addReminder(for: indexPath, timeOffset: 15)
            self.setStatusBarBackground(as: .white)
        }))
        actionSheet.addAction(UIAlertAction(title: "5 minutes before", style: .default, handler: { action in
            self.addReminder(for: indexPath, timeOffset: 5)
            self.setStatusBarBackground(as: .white)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
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

extension DayViewController {
    
    func initialiseUI() {
        generateEmptyCards()
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
    
    func generateEmptyCards() {
		blocks[Day.today.rawValue] = [Block]()
		blocks[Day.tomorrow.rawValue] = [Block]()
		
        for hour in 0...23 {
            blocks[Day.today.rawValue]?.append(Block(hour: hour, agendaItem: nil))
            blocks[Day.tomorrow.rawValue]?.append(Block(hour: hour, agendaItem: nil))
        }
    }
    
    func checkAppUpgrade() {
        let currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        let versionOfLastRun = UserDefaults.standard.object(forKey: "VersionOfLastRun") as? String
        
        if versionOfLastRun != nil && versionOfLastRun != currentVersion {
            presentWhatsNew()
        }
        
        UserDefaults.standard.set(currentVersion, forKey: "VersionOfLastRun")
        UserDefaults.standard.synchronize()
    }
    
    func presentWhatsNew() {
        let whatsNew = WhatsNew(
            title: "What's New in Version 1.1",
            items: [
                WhatsNew.Item(
                    title: "Apple Watch App",
                    subtitle: "Quickly glance at your day with the teeny tiny Hour Blocks Apple Watch app ⌚️",
                    image: nil
				),
				WhatsNew.Item(
					title: "Clever Icons",
					subtitle: "Icons are now automatically generated using Machine Learning for more accurate results 🎓",
					image: nil
				),
                WhatsNew.Item(
                    title: "Minor Improvements",
                    subtitle: "All day Calendar events now show in the header and the return key when editing/adding an hour block now acts as a 'Done' button 🎉",
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
    
    func showConnectionToast() {
        DispatchQueue.main.async {
            ToastView.appearance().font = .systemFont(ofSize: 17)
            ToastView.appearance().cornerRadius = 8
            ToastView.appearance().textInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
            ToastView.appearance().bottomOffsetPortrait = 48
            
            Toast(text: "I'm having some trouble fetching your Hour Blocks from iCloud 😞\nPlease check your network connection", duration: 10).show()
        }
    }
}

// MARK: - Watch

extension DayViewController: WCSessionDelegate {
	
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
