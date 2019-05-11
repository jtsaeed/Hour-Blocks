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
    
    var todayCards = [AgendaCard]() {
        didSet {
            todayCards = todayCards.filter { $0.hour >= Calendar.current.component(.hour, from: Date()) }
        }
    }
    var tomorrowCards = [AgendaCard]()

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
        todayCards.removeAll()
        tomorrowCards.removeAll()
        for hour in 0...23 {
            todayCards.append(AgendaCard(hour: hour, agendaItem: todayAgendaItems[hour]))
            tomorrowCards.append(AgendaCard(hour: hour, agendaItem: tomorrowAgendaItems[hour]))
        }
		
		copyToWatch(data: todayCards)
    }
    
    func addCard(for indexPath: IndexPath, with title: String) {
        let agendaItem = AgendaItem(title: title)
        
        if indexPath.section == SectionType.today.rawValue {
            if let agendaItem = todayCards[indexPath.row].agendaItem { DataGateway.shared.delete(agendaItem) }
            DataGateway.shared.save(agendaItem, for: todayCards[indexPath.row].hour, today: true)
            todayCards[indexPath.row].agendaItem = agendaItem
            if #available(iOS 12.0, *) { donateInteraction(for: todayCards[indexPath.row]) }
        } else if indexPath.section == SectionType.tomorrow.rawValue {
            if let agendaItem = tomorrowCards[indexPath.row].agendaItem { DataGateway.shared.delete(agendaItem) }
            DataGateway.shared.save(agendaItem, for: tomorrowCards[indexPath.row].hour, today: false)
            tomorrowCards[indexPath.row].agendaItem = agendaItem
        }
		
		copyToWatch(data: todayCards)
        tableView.reloadRows(at: [indexPath], with: .fade)
        
        handleReviewRequest()
    }
    
    func removeCard(for indexPath: IndexPath) {
        if indexPath.section == SectionType.today.rawValue {
            DataGateway.shared.delete(todayCards[indexPath.row].agendaItem!)
            todayCards[indexPath.row].agendaItem = nil
        } else if indexPath.section == SectionType.tomorrow.rawValue {
            DataGateway.shared.delete(tomorrowCards[indexPath.row].agendaItem!)
            tomorrowCards[indexPath.row].agendaItem = nil
        }
		
		copyToWatch(data: todayCards)
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    func isCalendarEvent(at indexPath: IndexPath) -> Bool {
        if indexPath.section == SectionType.today.rawValue {
            return todayCards[indexPath.row].agendaItem!.icon == "calendar"
        } else if indexPath.section == SectionType.tomorrow.rawValue {
            return tomorrowCards[indexPath.row].agendaItem!.icon == "calendar"
        } else {
            return false
        }
    }
    
    func hasReminderSet(at indexPath: IndexPath, completion: @escaping (_ result: Bool) -> ()) {
        if indexPath.section == SectionType.today.rawValue {
            NotificationsGateway.shared.hasPendingNotification(for: todayCards[indexPath.row]) { (result) in
                completion(result)
            }
        } else if indexPath.section == SectionType.tomorrow.rawValue {
            NotificationsGateway.shared.hasPendingNotification(for: tomorrowCards[indexPath.row]) { (result) in
                completion(result)
            }
        } else {
            completion(false)
        }
    }
    
    func addReminder(for indexPath: IndexPath, timeOffset: Int) {
        if indexPath.section == SectionType.today.rawValue {
			NotificationsGateway.shared.addNotification(for: todayCards[indexPath.row], with: timeOffset, today: true, completion: { (success) in
                if success {
                    DispatchQueue.main.async { UINotificationFeedbackGenerator().notificationOccurred(.success) }
                } else {
                    DispatchQueue.main.async { UINotificationFeedbackGenerator().notificationOccurred(.error) }
                }
            })
        } else if indexPath.section == SectionType.tomorrow.rawValue {
			NotificationsGateway.shared.addNotification(for: tomorrowCards[indexPath.row], with: timeOffset, today: false, completion: { (success) in
                if success {
                    DispatchQueue.main.async { UINotificationFeedbackGenerator().notificationOccurred(.success) }
                } else {
                    DispatchQueue.main.async { UINotificationFeedbackGenerator().notificationOccurred(.error) }
                }
            })
        }
    }
    
    func removeReminder(for indexPath: IndexPath) {
        if indexPath.section == SectionType.today.rawValue {
            NotificationsGateway.shared.removeNotification(for: todayCards[indexPath.row])
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        } else if indexPath.section == SectionType.tomorrow.rawValue {
            NotificationsGateway.shared.removeNotification(for: tomorrowCards[indexPath.row])
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
    }
    
    func handleReviewRequest() {
        let count = DataGateway.shared.getTotalAgendaCount()
        
        if count == 10 || count == 25 || count == 50 {
            SKStoreReviewController.requestReview()
        }
    }
    
    @available(iOS 12.0, *)
    func donateInteraction(for agendaCard: AgendaCard) {
        let interaction = INInteraction(intent: agendaCard.intent, response: nil)
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
        
        if section == SectionType.today.rawValue {
            sectionHeader.build(for: .today)
        } else if section == SectionType.tomorrow.rawValue {
            sectionHeader.build(for: .tomorrow)
        }
        
        return sectionHeader
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == SectionType.today.rawValue {
            return todayCards.count
        } else if section == SectionType.tomorrow.rawValue {
            return tomorrowCards.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == SectionType.today.rawValue {
            if !todayCards[indexPath.row].isEmpty { showAgendaOptionsDialog(for: todayCards[indexPath.row], at: indexPath) }
        } else if indexPath.section == SectionType.tomorrow.rawValue {
            if !tomorrowCards[indexPath.row].isEmpty { showAgendaOptionsDialog(for: tomorrowCards[indexPath.row], at: indexPath) }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let spacer = tableView.reorder.spacerCell(for: indexPath) { return spacer }
		
        if indexPath.section == SectionType.today.rawValue {
            return buildCell(with: todayCards[indexPath.row].agendaItem,
                             for: todayCards[indexPath.row].hour,
                             at: indexPath)
        } else if indexPath.section == SectionType.tomorrow.rawValue {
            return buildCell(with: tomorrowCards[indexPath.row].agendaItem,
                             for: tomorrowCards[indexPath.row].hour,
                             at: indexPath)
        } else {
            return UITableViewCell()
        }
    }
	
	func tableView(_ tableView: UITableView, reorderRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) { }
	
	func tableView(_ tableView: UITableView, canReorderRowAt indexPath: IndexPath) -> Bool {
		if indexPath.section == SectionType.today.rawValue {
			return todayCards[indexPath.row].agendaItem != nil
		} else if indexPath.section == SectionType.tomorrow.rawValue {
			return tomorrowCards[indexPath.row].agendaItem != nil
		} else {
			return false
		}
	}
	
	func tableViewDidBeginReordering(_ tableView: UITableView, at indexPath: IndexPath) {
		UIImpactFeedbackGenerator(style: .medium).impactOccurred()
	}
	
	func tableViewDidFinishReordering(_ tableView: UITableView, from initialSourceIndexPath: IndexPath, to finalDestinationIndexPath: IndexPath) {
		if initialSourceIndexPath.section == SectionType.today.rawValue {
			let agendaItem = todayCards[initialSourceIndexPath.row].agendaItem!
			DataGateway.shared.delete(todayCards[initialSourceIndexPath.row].agendaItem!)
			todayCards[initialSourceIndexPath.row].agendaItem = nil
			
			todayCards[finalDestinationIndexPath.row].agendaItem = agendaItem
			DataGateway.shared.save(agendaItem, for: todayCards[finalDestinationIndexPath.row].hour, today: true)
		} else if initialSourceIndexPath.section == SectionType.tomorrow.rawValue {
			let agendaItem = tomorrowCards[initialSourceIndexPath.row].agendaItem!
			DataGateway.shared.delete(tomorrowCards[initialSourceIndexPath.row].agendaItem!)
			tomorrowCards[initialSourceIndexPath.row].agendaItem = nil
			
			tomorrowCards[finalDestinationIndexPath.row].agendaItem = agendaItem
			DataGateway.shared.save(agendaItem, for: tomorrowCards[finalDestinationIndexPath.row].hour, today: true)
		}
		
		UINotificationFeedbackGenerator().notificationOccurred(.success)
		tableView.reloadData()
	}
    
    func buildCell(with agendaItem: AgendaItem?, for hour: Int, at indexPath: IndexPath) -> UITableViewCell {
        if let unwrappedAgendaItem = agendaItem {
            return buildAgendaCell(with: unwrappedAgendaItem, for: hour)
        } else {
            return buildEmptyCell(for: hour, at: indexPath)
        }
    }
    
    func buildAgendaCell(with agendaItem: AgendaItem, for hour: Int) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "todayAgendaCell") as? AgendaCardCell else { return UITableViewCell() }
        cell.build(with: agendaItem, for: hour)
        return cell
    }
    
    func buildEmptyCell(for hour: Int, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "todayEmptyCell") as? EmptyCardCell else { return UITableViewCell() }
        cell.build(for: hour, at: indexPath)
        cell.delegate = self
        return cell
    }
}

// MARK: - Dialogs

extension DayViewController: AddAgendaDelegate, AddAgendaAlertViewDelegate {
    
    func showAddAgendaDialog(for agendaCard: AgendaCard?, at indexPath: IndexPath) {
        let alert = self.storyboard?.instantiateViewController(withIdentifier: "AddAgendaAlert") as! AddAgendAlertViewController
        alert.providesPresentationContextTransitionStyle = true
        alert.definesPresentationContext = true
        alert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        alert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        alert.delegate = self
        alert.indexPath = indexPath
        alert.preFilledTitle = agendaCard?.agendaItem?.title
        
        if indexPath.section == SectionType.today.rawValue {
            alert.time = todayCards[indexPath.row].hour.getFormattedHour().lowercased()
        } else if indexPath.section == SectionType.tomorrow.rawValue {
            alert.time = tomorrowCards[indexPath.row].hour.getFormattedHour().lowercased()
        }
        
        setStatusBarBackground(as: .clear)
        present(alert, animated: true, completion: nil)
    }
    
    func doneButtonTapped(textFieldValue: String, indexPath: IndexPath) {
        addCard(for: indexPath, with: textFieldValue)
        setStatusBarBackground(as: .white)
    }
    
    func cancelButtonTapped() {
        setStatusBarBackground(as: .white)
    }
    
    func showAgendaOptionsDialog(for agendaCard: AgendaCard, at indexPath: IndexPath) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { action in
            self.showAddAgendaDialog(for: agendaCard, at: indexPath)
        }))
        if (!isCalendarEvent(at: indexPath)) {
            actionSheet.addAction(UIAlertAction(title: "Clear", style: .destructive, handler: { action in
                self.removeCard(for: indexPath)
                self.setStatusBarBackground(as: .white)
            }))
			
			if indexPath.section == SectionType.today.rawValue {
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
        for hour in 0...23 {
            todayCards.append(AgendaCard(hour: hour, agendaItem: nil))
            tomorrowCards.append(AgendaCard(hour: hour, agendaItem: nil))
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
	
	func copyToWatch(data todayCards: [AgendaCard]) {
		var watchAgendaItems = [Int: String]()
		
		for hour in 0...23 {
			watchAgendaItems[hour] = "Empty"
		}
		
		for todayCard in todayCards {
			watchAgendaItems[todayCard.hour] = todayCard.agendaItem?.title
		}
		
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
