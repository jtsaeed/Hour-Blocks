//
//  AgendaItem.swift
//  neon
//
//  Created by James Saeed on 06/02/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import Foundation

struct AgendaItem {
    
    var title: String
    var icon: String
    
    init(title: String, icon: String) {
        self.title = title
        self.icon = icon
    }
    
    init(title: String) {
        self.title = title
        self.icon = "people"
        
        if doesTitleContain(["draw", "paint", "art"]) {
            self.icon = "brush"
        } else if doesTitleContain(["develop", "developing", "code", "coding", "programming", "software", "app"]) {
            self.icon = "code"
        } else if doesTitleContain(["commute", "commuting", "drive", "driving", "journey", "travel"]) {
            self.icon = "commute"
        } else if doesTitleContain(["relax", "chill"]) {
            self.icon = "couch"
        } else if doesTitleContain(["study", "lecture", "school", "read"]) {
            self.icon = "education"
        } else if doesTitleContain(["breakfast", "lunch", "dinner", "food", "meal", "eat"]) {
            self.icon = "food"
        } else if doesTitleContain(["gym", "exercise", "run"]) {
            self.icon = "gym"
        } else if doesTitleContain(["date", "romantic"]) {
            self.icon = "love"
        } else if doesTitleContain(["movie", "film", "cinema"]) {
            self.icon = "movie"
        } else if doesTitleContain(["music", "concert"]) {
            self.icon = "music"
        } else if doesTitleContain(["write", "writing"]) {
            self.icon = "pencil"
        } else if doesTitleContain(["party", "friend"]) {
            self.icon = "people"
        } else if doesTitleContain(["shop"]) {
            self.icon = "store"
        } else if doesTitleContain(["morning", "beach"]) {
            self.icon = "sun"
        } else if doesTitleContain(["tv", "episode"]) {
            self.icon = "tv"
        } else if doesTitleContain(["work", "meeting"]) {
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
