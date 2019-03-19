//
//  DataGateway.swift
//  neon
//
//  Created by James Saeed on 18/03/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import Foundation

class DataGateway {
    
    static let shared = DataGateway()
    
    func saveAgendaItemToday(_ agendaItem: AgendaItem, for hour: Int) {
        StorageGateway.shared.saveAgendaItem(agendaItem, for: hour, today: true)
        CloudGateway.shared.saveAgendaRecord(agendaItem, for: hour, today: true)
    }
    
    func saveAgendaItemTomorrow(_ agendaItem: AgendaItem, for hour: Int) {
        StorageGateway.shared.saveAgendaItem(agendaItem, for: hour, today: false)
        CloudGateway.shared.saveAgendaRecord(agendaItem, for: hour, today: false)
    }
    
    func loadTodaysAgendaItems() -> [Int: AgendaItem] {
        return StorageGateway.shared.loadTodaysAgendaItems()
    }
    
    func loadTomorrowsAgendaItems() -> [Int: AgendaItem] {
        return StorageGateway.shared.loadTomorrowsAgendaItems()
    }
    
    func pullTodaysNewAgendaItems() {
        // TODO CloudGateway pull, then in the closure, save result using storagegateway
    }
    
    func pullTomorrowsNewAgendaItems() {
        // TODO CloudGateway pull, then in the closure, save result using storagegateway
    }
    
    func deleteAgendaItem(from agendaCard: AgendaCard) {
        StorageGateway.shared.deleteAgendaItem(from: agendaCard.agendaItem!, for: agendaCard.hour)
        // TODO CloudGateway.shared.deleteAgendaRecord(from: agendaCard.agendaItem!, for: agendaCard.hour)
    }
    
    func cleanPastAgendaItems() {
        // TODO StorageGateway.shared.deletePastAgendaItems()
        // TODO CloudGateway.shared.deletePastAgendaRecords()
    }
}
