//
//  ViewController.swift
//  neon
//
//  Created by James Saeed on 06/02/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import UIKit
import EventKit
import WhatsNewKit
import UserNotifications

class DayViewController: UITableViewController {
    
    var todayCards = [AgendaCard]() {
        didSet {
            todayCards = todayCards.filter { $0.hour >= Calendar.current.component(.hour, from: Date()) }
        }
    }
    var tomorrowCards = [AgendaCard]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialiseUI()
        NotificationCenter.default.addObserver(self, selector: #selector(loadAgendaItems), name: Notification.Name("agendaUpdate"), object: nil)
        DataGateway.shared.deletePastAgendaRecords()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadAgendaItems()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        checkAppUpgrade()
    }
    
    @IBAction func pulledToRefresh(_ sender: UIRefreshControl) {
        DataGateway.shared.fetchAgendaItems { (todaysAgendaItems, tomorrowsAgendaItems) in
            self.generateCards(from: todaysAgendaItems, and: tomorrowsAgendaItems)
            DispatchQueue.main.async { sender.endRefreshing() }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.tableView.reloadData()
            })
        }
    }
}

// MARK: - Functionality

extension DayViewController {
    
    @objc func loadAgendaItems() {
        DataGateway.shared.fetchAgendaItems { (todaysAgendaItems, tomorrowsAgendaItems) in
            self.generateCards(from: todaysAgendaItems, and: tomorrowsAgendaItems)
            DispatchQueue.main.async { self.tableView.reloadData() }
        }
    }
    
    func generateCards(from todayAgendaItems: [Int: AgendaItem], and tomorrowAgendaItems: [Int: AgendaItem]) {
        todayCards.removeAll()
        tomorrowCards.removeAll()
        for hour in 0...23 {
            todayCards.append(AgendaCard(hour: hour, agendaItem: todayAgendaItems[hour]))
            tomorrowCards.append(AgendaCard(hour: hour, agendaItem: tomorrowAgendaItems[hour]))
        }
    }
    
    func addCard(for indexPath: IndexPath, with title: String) {
        let agendaItem = AgendaItem(title: title)
        
        if indexPath.section == SectionType.today.rawValue {
            if let agendaItem = todayCards[indexPath.row].agendaItem { DataGateway.shared.delete(agendaItem) }
            DataGateway.shared.save(agendaItem, for: todayCards[indexPath.row].hour, today: true)
            todayCards[indexPath.row].agendaItem = agendaItem
        } else if indexPath.section == SectionType.tomorrow.rawValue {
            if let agendaItem = todayCards[indexPath.row].agendaItem { DataGateway.shared.delete(agendaItem) }
            DataGateway.shared.save(agendaItem, for: tomorrowCards[indexPath.row].hour, today: false)
            tomorrowCards[indexPath.row].agendaItem = agendaItem
        }
        
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    func removeCard(for indexPath: IndexPath) {
        if indexPath.section == SectionType.today.rawValue {
            DataGateway.shared.delete(todayCards[indexPath.row].agendaItem!)
            todayCards[indexPath.row].agendaItem = nil
        } else if indexPath.section == SectionType.tomorrow.rawValue {
            DataGateway.shared.delete(tomorrowCards[indexPath.row].agendaItem!)
            tomorrowCards[indexPath.row].agendaItem = nil
        }
        
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
            NotificationsGateway.shared.addNotification(for: todayCards[indexPath.row], with: timeOffset, completion: { (success) in
                if success {
                    DispatchQueue.main.async { UINotificationFeedbackGenerator().notificationOccurred(.success) }
                } else {
                    DispatchQueue.main.async { UINotificationFeedbackGenerator().notificationOccurred(.error) }
                }
            })
        } else if indexPath.section == SectionType.tomorrow.rawValue {
            NotificationsGateway.shared.addNotification(for: tomorrowCards[indexPath.row], with: timeOffset, completion: { (success) in
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
}

// MARK: - Table View

extension DayViewController {
    
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
            if !todayCards[indexPath.row].isEmpty { showAgendaOptionsDialog(for: indexPath) }
        } else if indexPath.section == SectionType.tomorrow.rawValue {
            if !tomorrowCards[indexPath.row].isEmpty { showAgendaOptionsDialog(for: indexPath) }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    func showAddAgendaDialog(for indexPath: IndexPath) {
        let alert = self.storyboard?.instantiateViewController(withIdentifier: "AddAgendaAlert") as! AddAgendAlertViewController
        alert.providesPresentationContextTransitionStyle = true
        alert.definesPresentationContext = true
        alert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        alert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        alert.delegate = self
        alert.indexPath = indexPath
        
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
    
    func showAgendaOptionsDialog(for indexPath: IndexPath) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { action in
            self.showAddAgendaDialog(for: indexPath)
        }))
        if (!isCalendarEvent(at: indexPath)) {
            actionSheet.addAction(UIAlertAction(title: "Clear", style: .destructive, handler: { action in
                self.removeCard(for: indexPath)
                self.setStatusBarBackground(as: .white)
            }))
            
            hasReminderSet(at: indexPath) { (result) in
                print(result)
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
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            self.setStatusBarBackground(as: .white)
        }))
        
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
    
    func presentWhatsNew() {
        let whatsNew = WhatsNew(
            title: "What's New in Beta 3.0",
            items: [
                WhatsNew.Item(
                    title: "Reminders",
                    subtitle: "Hour Blocks can now have reminders attached to them that fire off at the start of the hour 🔔",
                    image: nil
                ),
                WhatsNew.Item(
                    title: "Widget",
                    subtitle: "You can now add a widget to your home/lock screen to display the current Hour Block 👀",
                    image: nil
                ),
                WhatsNew.Item(
                    title: "Apple Watch Support",
                    subtitle: "A basic version of Hour Blocks now runs on the Apple Watch, showing you your Hour Blocks for today ⌚️",
                    image: nil
                ),
                WhatsNew.Item(
                    title: "Bug Fixes & Improvements",
                    subtitle: "Fixed a few layout bugs on iPads and smaller iPhones & some random crashes, and implemented some other small improvements 🐜",
                    image: nil
                )
            ]
        )
        var configuration = WhatsNewViewController.Configuration()
        configuration.completionButton.backgroundColor = UIColor(named: "main")!
        configuration.completionButton.title = "Let's go!"
        configuration.completionButton.hapticFeedback = .impact(.light)
        configuration.completionButton.action = .custom(action: { vc in
            vc.dismiss(animated: true, completion: {
                CalendarGateway.shared.handlePermissions()
            })
        })
        let whatsNewVC = WhatsNewViewController(whatsNew: whatsNew, configuration: configuration)
        
        self.present(whatsNewVC, animated: true, completion: nil)
    }
    
    func setupTableView() {
        tableView.frame = .zero
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
        
        if versionOfLastRun != currentVersion {
            presentWhatsNew()
        }
        
        UserDefaults.standard.set(currentVersion, forKey: "VersionOfLastRun")
        UserDefaults.standard.synchronize()
    }
}


