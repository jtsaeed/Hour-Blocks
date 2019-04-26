//
//  InterfaceController.swift
//  neonWatch Extension
//
//  Created by James Saeed on 26/03/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet weak var tableView: WKInterfaceTable!
    
    var todayCards = [AgendaCard]() {
        didSet {
            todayCards = todayCards.filter { $0.hour >= Calendar.current.component(.hour, from: Date()) }
        }
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        DataGateway.shared.fetchAgendaItems { (todaysAgendaItems, _, success) in
            if success {
                self.generateCards(from: todaysAgendaItems)
                self.updateTableView()
            } else {
                self.showError()
            }
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        DataGateway.shared.fetchAgendaItems { (todaysAgendaItems, _, success) in
            if success {
                self.generateCards(from: todaysAgendaItems)
                self.updateTableView()
            } else {
                self.showError()
            }
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func generateCards(from todayAgendaItems: [Int: AgendaItem]) {
        DispatchQueue.main.async {
            self.todayCards.removeAll()
            for hour in 0...23 {
                self.todayCards.append(AgendaCard(hour: hour, agendaItem: todayAgendaItems[hour]))
            }
        }
    }
    
    func updateTableView() {
        tableView.setNumberOfRows(todayCards.count, withRowType: "agendaCardRow")
        for index in 0 ..< tableView.numberOfRows {
            guard let controller = tableView.rowController(at: index) as? AgendaCardRowController else { continue }
            
            controller.agendaCard = todayCards[index]
        }
    }
    
    func showError() {
        DispatchQueue.main.async {
            let action = WKAlertAction(title: "OK", style: .default) {}
            self.presentAlert(withTitle: "Error", message: "I'm having some trouble fetching your Hour Blocks from iCloud, please check your network connection", preferredStyle: .alert, actions: [action])
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
