//
//  InterfaceController.swift
//  neonWatch Extension
//
//  Created by James Saeed on 26/03/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {
	
	let session = WCSession.default

    @IBOutlet weak var tableView: WKInterfaceTable!
    
    var todayCards = [AgendaCard]() {
        didSet {
            todayCards = todayCards.filter { $0.hour >= Calendar.current.component(.hour, from: Date()) }
        }
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
		
		self.processConnectivity()
		
		session.delegate = self
		session.activate()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
		super.willActivate()
    }
	
	func processConnectivity() {
		print("I'm being called!")
		
		if let phoneContext = session.receivedApplicationContext as? [String: [Int: String]] {
			generateCards(from: phoneContext["todaysAgendaItems"])
			updateTableView()
		}
	}
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func generateCards(from todayAgendaItems: [Int: String]?) {
		self.todayCards.removeAll()
		for hour in 0...23 {
			self.todayCards.append(AgendaCard(hour: hour, agendaItem: AgendaItem(title: todayAgendaItems?[hour] ?? "Empty")))
			print(todayCards.last?.agendaItem?.title ?? "Empty")
		}
    }
    
    func updateTableView() {
        tableView.setNumberOfRows(todayCards.count, withRowType: "agendaCardRow")
        for index in 0 ..< tableView.numberOfRows {
            guard let controller = tableView.rowController(at: index) as? AgendaCardRowController else { continue }
            
            controller.agendaCard = todayCards[index]
        }
    }
	
	func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
		DispatchQueue.main.async {
			self.processConnectivity()
		}
	}
	
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) { }
}

struct AgendaCard {
    
    let hour: Int
    var agendaItem: AgendaItem?
    var isEmpty: Bool {
        return agendaItem == nil
    }
}
