//
//  ViewController.swift
//  neon
//
//  Created by James Saeed on 06/02/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import UIKit
import SwipeCellKit

class TodayViewController: UITableViewController {
    
    var cards = [TodayCard]() {
        didSet {
            cards = cards.filter { $0.hour >= Calendar.current.component(.hour, from: Date()) }
        }
    }
    var agendaItems = [Int: AgendaItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStatusBarBackground(as: .white)
        generateCards(from: DataGateway.shared.loadTodaysAgendaItems())
    }
}

// MARK: - Functionality

extension TodayViewController {
    func generateCards(from agendaItems: [Int: AgendaItem]) {
        for hour in 0...23 {
            cards.append(TodayCard(hour: hour, agendaItem: agendaItems[hour]))
        }
    }
}

// MARK: - Table View

extension TodayViewController: AddAgendaDelegate {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "todayHeaderCell") as? TodayHeaderCell else { return UITableViewCell() }
            cell.build()
            return cell
        } else {
            let cardPosition = indexPath.row - 1
            if let agendaItem = cards[cardPosition].agendaItem {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "todayAgendaCell") as? TodayAgendaCell else { return UITableViewCell() }
                cell.build(with: agendaItem, forHour: cards[cardPosition].hour)
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "todayEmptyCell") as? TodayEmptyCell else { return UITableViewCell() }
                cell.build(forHour: cards[cardPosition].hour, atPosition: cardPosition)
                cell.delegate = self
                return cell
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, handler) in
            self.showAddAgendaDialog(forCardPosition: indexPath.row - 1)
        }
        edit.backgroundColor = UIColor(named: "main")
        
        let clear = UIContextualAction(style: .normal, title: "Clear") { (action, view, handler) in
            // TODO: clear agenda item
        }
        clear.backgroundColor = UIColor(named: "main")
        
        return UISwipeActionsConfiguration(actions: [clear, edit])
    }
}

// MARK: - Dialogs

extension TodayViewController: AddAgendaAlertViewDelegate {
    
    func doneButtonTapped(textFieldValue: String, cardPosition: Int) {
        let agendaItem = AgendaItem(title: textFieldValue)
        DataGateway.shared.saveAgendaItem(agendaItem, for: self.cards[cardPosition].hour)
        self.cards[cardPosition].agendaItem = agendaItem
        self.tableView.reloadRows(at: [IndexPath(row: cardPosition + 1, section: 0)], with: .fade)
        self.setStatusBarBackground(as: .white)
    }
    
    func showAddAgendaDialog(forCardPosition cardPosition: Int) {
        let alert = self.storyboard?.instantiateViewController(withIdentifier: "AddAgendaAlert") as! AddAgendAlertViewController
        alert.providesPresentationContextTransitionStyle = true
        alert.definesPresentationContext = true
        alert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        alert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        alert.delegate = self
        alert.cardPosition = cardPosition
        alert.time = cards[cardPosition].hour.getFormattedHour().lowercased()
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

struct TodayCard {
    
    let hour: Int
    var agendaItem: AgendaItem?
}
