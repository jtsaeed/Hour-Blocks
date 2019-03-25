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
    
    func initSubscriptions() {
        CloudGateway.shared.initSubscription("New Agenda Record", forType: .firesOnRecordCreation)
        CloudGateway.shared.initSubscription("Updated Agenda Record", forType: .firesOnRecordUpdate)
        CloudGateway.shared.initSubscription("Deleted Agenda Record", forType: .firesOnRecordDeletion)
    }
    
    func save(_ agendaItem: AgendaItem, for hour: Int, today: Bool) {
        StorageGateway.shared.save(agendaItem, for: hour, today: today)
        CloudGateway.shared.save(agendaItem, for: hour, today: today)
    }
    
    func loadTodaysAgendaItems() -> [Int: AgendaItem] {
        return StorageGateway.shared.loadTodaysAgendaItems()
    }
    
    func loadTomorrowsAgendaItems() -> [Int: AgendaItem] {
        return StorageGateway.shared.loadTomorrowsAgendaItems()
    }
    
    func fetchTodaysNewAgendaItems(checkAgainst agendaItems: [AgendaItem], completion: @escaping () -> ()) {
        CloudGateway.shared.fetchTodaysNewAgendaItems(checkAgainst: agendaItems.map({ $0.id })) { (agendaItems) in
            for agendaItem in agendaItems {
                let hour = agendaItem.key
                StorageGateway.shared.save(agendaItem.value, for: hour, today: true)
            }
            completion()
        }
    }
    
    func fetchTomorrowsNewAgendaItems() {
        // TODO CloudGateway pull, then in the closure, save result using storagegateway
    }
    
    func delete(_ agendaItem: AgendaItem) {
        StorageGateway.shared.delete(agendaItem)
        // TODO CloudGateway.shared.deleteAgendaRecord(from: agendaCard.agendaItem!, for: agendaCard.hour)
    }
    
    func cleanPastAgendaItems() {
        // TODO StorageGateway.shared.deletePastAgendaItems()
        // TODO CloudGateway.shared.deletePastAgendaRecords()
    }
}
