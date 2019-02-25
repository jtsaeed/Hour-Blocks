//
//  ViewController.swift
//  neon
//
//  Created by James Saeed on 06/02/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import UIKit
import SwipeCellKit
import EventKit

class TodayViewController: UITableViewController {
    
    var todayCards = [AgendaCard]() {
        didSet {
            todayCards = todayCards.filter { $0.hour >= Calendar.current.component(.hour, from: Date()) }
        }
    }
    var tomorrowCards = [AgendaCard]()
    var agendaItems = [Int: AgendaItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.frame = .zero
        setStatusBarBackground(as: .white)
        generateCards(from: DataGateway.shared.loadTodaysAgendaItems(),
                      and: DataGateway.shared.loadTomorrowsAgendaItems())
    }
}

// MARK: - Functionality

extension TodayViewController {
    
    func generateCards(from todayAgendaItems: [Int: AgendaItem], and tomorrowAgendaItems: [Int: AgendaItem]) {
        for hour in 0...23 {
            todayCards.append(AgendaCard(hour: hour, agendaItem: todayAgendaItems[hour]))
            tomorrowCards.append(AgendaCard(hour: hour, agendaItem: tomorrowAgendaItems[hour]))
        }
    }
    
    func addCard(for indexPath: IndexPath, with title: String) {
        let agendaItem = AgendaItem(title: title)
        
        if indexPath.section == SectionType.today.rawValue {
            DataGateway.shared.saveAgendaItem(agendaItem, for: self.todayCards[indexPath.row].hour, today: true)
            self.todayCards[indexPath.row].agendaItem = agendaItem
        } else if indexPath.section == SectionType.tomorrow.rawValue {
            DataGateway.shared.saveAgendaItem(agendaItem, for: self.tomorrowCards[indexPath.row].hour, today: false)
            self.tomorrowCards[indexPath.row].agendaItem = agendaItem
        }
        
        self.tableView.reloadRows(at: [indexPath], with: .fade)
    }
}

// MARK: - Table View

extension TodayViewController {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 112
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 112))
        guard let sectionHeader = Bundle.main.loadNibNamed("SectionHeaderView", owner: self, options: nil)?.first as? SectionHeaderView else { return UIView() }
        
        if section == SectionType.today.rawValue {
            sectionHeader.build(for: .today)
        } else if section == SectionType.tomorrow.rawValue {
            sectionHeader.build(for: .tomorrow)
        }
        
        view.addSubview(sectionHeader)
        return view
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SectionType.today.rawValue {
            if let agendaItem = todayCards[indexPath.row].agendaItem {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "todayAgendaCell") as? AgendaCardCell else { return UITableViewCell() }
                cell.build(with: agendaItem, forHour: todayCards[indexPath.row].hour)
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "todayEmptyCell") as? EmptyCardCell else { return UITableViewCell() }
                cell.build(for: todayCards[indexPath.row].hour, at: indexPath)
                cell.delegate = self
                return cell
            }
        } else if indexPath.section == SectionType.tomorrow.rawValue {
            if let agendaItem = tomorrowCards[indexPath.row].agendaItem {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "todayAgendaCell") as? AgendaCardCell else { return UITableViewCell() }
                cell.build(with: agendaItem, forHour: tomorrowCards[indexPath.row].hour)
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "todayEmptyCell") as? EmptyCardCell else { return UITableViewCell() }
                cell.build(for: tomorrowCards[indexPath.row].hour, at: indexPath)
                cell.delegate = self
                return cell
            }
        } else {
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, handler) in
            self.showAddAgendaDialog(for: indexPath)
        }
        edit.backgroundColor = UIColor(named: "main")
        
        let clear = UIContextualAction(style: .normal, title: "Clear") { (action, view, handler) in
            // TODO
        }
        clear.backgroundColor = UIColor(named: "main")
        
        return UISwipeActionsConfiguration(actions: [clear, edit])
    }
}

// MARK: - Dialogs

extension TodayViewController: AddAgendaDelegate, AddAgendaAlertViewDelegate {
    
    func doneButtonTapped(textFieldValue: String, indexPath: IndexPath) {
        addCard(for: indexPath, with: textFieldValue)
        self.setStatusBarBackground(as: .white)
    }
    
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
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - UI

extension TodayViewController {
    
    func setStatusBarBackground(as color: UIColor) {
        // Make status bar white
        guard let statusBarView = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else {
            return
        }
        UIView.animate(withDuration: 0.2) {
            statusBarView.backgroundColor = color
        }
    }
}

struct AgendaCard {
    
    let hour: Int
    var agendaItem: AgendaItem?
}
