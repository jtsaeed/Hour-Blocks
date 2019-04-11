//
//  AgendaItem.swift
//  neon
//
//  Created by James Saeed on 06/02/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import Foundation

struct AgendaItem {
    
    var id: String
    var title: String
    var icon: String
    
    init(with id: String, and title: String) {
        self.id = id
        self.title = title
        self.icon = "default"
        generateIcon()
    }
    
    init(title: String) {
        self.id = UUID().uuidString
        self.title = title
        self.icon = "default"
        generateIcon()
    }
    
    mutating func generateIcon() {
        if doesTitleContain(["draw", "paint", "art"]) {
            self.icon = "brush"
        } else if doesTitleContain(["develop", "developing", "code", "coding", "programming", "software", "app"]) {
            self.icon = "code"
        } else if doesTitleContain(["commute", "commuting", "drive", "driving", "journey", "travel"]) {
            self.icon = "commute"
        } else if doesTitleContain(["relax", "chill"]) {
            self.icon = "couch"
        } else if doesTitleContain(["study", "lecture", "school", "read", "research", "revise", "revision"]) {
            self.icon = "education"
        } else if doesTitleContain(["breakfast", "lunch", "dinner", "food", "meal", "eat", "snack", "brunch"]) {
            self.icon = "food"
        } else if doesTitleContain(["game", "play"]) {
            self.icon = "game"
        } else if doesTitleContain(["gym", "exercise", "run"]) {
            self.icon = "gym"
        } else if doesTitleContain(["date", "romantic", "boyfriend", "girlfriend", "husband", "wife", "family"]) {
            self.icon = "love"
        } else if doesTitleContain(["movie", "film", "cinema"]) {
            self.icon = "movie"
        } else if doesTitleContain(["music", "concert", "gig"]) {
            self.icon = "music"
        } else if doesTitleContain(["write", "writing"]) {
            self.icon = "pencil"
        } else if doesTitleContain(["party", "friend"]) {
            self.icon = "people"
        } else if doesTitleContain(["shop", "shopping"]) {
            self.icon = "store"
        } else if doesTitleContain(["morning", "beach"]) {
            self.icon = "sun"
        } else if doesTitleContain(["tv", "episode"]) {
            self.icon = "tv"
        } else if doesTitleContain(["work", "meeting", "assignment", "project"]) {
            self.icon = "work"
        }
    }
    
    func doesTitleContain(_ words: [String]) -> Bool {
        for word in words {
            if title.lowercased().contains(word) {
                return true
            }
        }
        
        return false
    }
}

struct AgendaCard {
    
    let hour: Int
    var agendaItem: AgendaItem?
    var isEmpty: Bool {
        return agendaItem == nil
    }
    
    init(hour: Int, agendaItem: AgendaItem?) {
        self.hour = hour
        self.agendaItem = agendaItem
    }
    
    @available(iOS 12.0, *)
    var intent: AddAgendaCardIntent {
        let addAgendaCardIntent = AddAgendaCardIntent()
        addAgendaCardIntent.hour = hour.getFormattedHour().lowercased()
        addAgendaCardIntent.hourRaw = hour as NSNumber
        addAgendaCardIntent.title = agendaItem?.title
        return addAgendaCardIntent
    }
}
