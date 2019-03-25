//
//  ViewController.swift
//  neon
//
//  Created by James Saeed on 06/02/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import UIKit
import EventKit

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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadAgendaItems()
    }
    
    @IBAction func pulledToRefresh(_ sender: UIRefreshControl) {
        TestGateway.shared.fetchAgendaItems { (todaysAgendaItems, tomorrowsAgendaItems) in
            self.generateCards(from: todaysAgendaItems, and: tomorrowsAgendaItems)
            TestGateway.shared.deletePastAgendaRecords({ })
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
        TestGateway.shared.fetchAgendaItems { (todaysAgendaItems, tomorrowsAgendaItems) in
            self.generateCards(from: todaysAgendaItems, and: tomorrowsAgendaItems)
            TestGateway.shared.deletePastAgendaRecords({ })
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
            if let agendaItem = todayCards[indexPath.row].agendaItem { TestGateway.shared.delete(agendaItem) }
            todayCards[indexPath.row].agendaItem = agendaItem
            TestGateway.shared.save(agendaItem, for: todayCards[indexPath.row].hour, today: true)
        } else if indexPath.section == SectionType.tomorrow.rawValue {
            if let agendaItem = todayCards[indexPath.row].agendaItem { TestGateway.shared.delete(agendaItem) }
            tomorrowCards[indexPath.row].agendaItem = agendaItem
            TestGateway.shared.save(agendaItem, for: tomorrowCards[indexPath.row].hour, today: false)
        }
        
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    func removeCard(for indexPath: IndexPath) {
        if indexPath.section == SectionType.today.rawValue {
            TestGateway.shared.delete(todayCards[indexPath.row].agendaItem!)
            todayCards[indexPath.row].agendaItem = nil
        } else if indexPath.section == SectionType.tomorrow.rawValue {
            TestGateway.shared.delete(tomorrowCards[indexPath.row].agendaItem!)
            tomorrowCards[indexPath.row].agendaItem = nil
        }
        
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    func isCalendarEvent(at indexPath: IndexPath) -> Bool {
        if indexPath.section == SectionType.today.rawValue {
            return todayCards[indexPath.row].agendaItem!.icon == "calendar"
        } else if indexPath.section == SectionType.today.rawValue {
            return tomorrowCards[indexPath.row].agendaItem!.icon == "calendar"
        } else {
            return false
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
        
        if (isCalendarEvent(at: indexPath)) {
            actionSheet.addAction(UIAlertAction(title: "Info", style: .default, handler: { action in
                // TODO: Show info
            }))
        } else {
            actionSheet.addAction(UIAlertAction(title: "Clear", style: .destructive, handler: { action in
                self.removeCard(for: indexPath)
                self.setStatusBarBackground(as: .white)
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            actionSheet.dismiss(animated: true, completion: nil)
            self.setStatusBarBackground(as: .white)
        }))
        
        setStatusBarBackground(as: .clear)
        present(actionSheet, animated: true, completion: nil)
    }
}

// MARK: - UI

extension DayViewController {
    
    func initialiseUI() {
        setupTableView()
        setStatusBarBackground(as: .white)
        CalendarGateway.shared.handlePermissions()
        generateEmptyCards()
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
}

struct AgendaCard {
    
    let hour: Int
    var agendaItem: AgendaItem?
    var isEmpty: Bool {
        return agendaItem == nil
    }
}
