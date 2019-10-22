//
//  AgendaItem.swift
//  neon
//
//  Created by James Saeed on 06/02/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import Foundation
import NaturalLanguage

struct AgendaItem {
    
    var id: String
    var title: String
    var icon: String
    
    init(with id: String, and title: String) {
        self.id = id
        self.title = title.lowercased()
        self.icon = "default"
        generateIcon()
    }
    
    init(title: String) {
        self.id = UUID().uuidString
        self.title = title.lowercased()
        self.icon = "default"
        generateIcon()
    }
    
    mutating func generateIcon() {
		if #available(iOS 12.0, *) {
			if Locale.current.languageCode == "es" || Locale.current.languageCode == "fr" {
				if let icon = generateLegacyIcon() { self.icon = icon }
			} else {
				if let icon = generateMLIcon() { self.icon = icon }
			}
		} else {
			if let icon = generateLegacyIcon() { self.icon = icon }
		}
        
        if let icon = generateEasterEggIcon() { self.icon = icon }
    }
	
	@available(iOS 12.0, *)
	func generateMLIcon() -> String? {
		do {
			let generator = try NLModel(mlModel: IconClassifier().model)
			return generator.predictedLabel(for: title)
		} catch _ {
			return nil
		}
	}
	
	func generateLegacyIcon() -> String? {
		if doesTitleContain(AppStrings.Icons.bank) {
			return "bank"
		} else if doesTitleContain(AppStrings.Icons.brush) {
			return "brush"
		} else if doesTitleContain(AppStrings.Icons.code) {
			return "code"
		} else if doesTitleContain(AppStrings.Icons.commute) {
			return "commute"
		} else if doesTitleContain(AppStrings.Icons.couch) {
			return "couch"
		} else if doesTitleContain(AppStrings.Icons.education) {
			return "education"
		} else if doesTitleContain(AppStrings.Icons.food) {
			return "food"
		} else if doesTitleContain(AppStrings.Icons.game) {
			return "game"
		} else if doesTitleContain(AppStrings.Icons.gym) {
			return "gym"
		} else if doesTitleContain(AppStrings.Icons.health) {
			return "health"
		} else if doesTitleContain(AppStrings.Icons.house) {
			return "house"
		} else if doesTitleContain(AppStrings.Icons.love) {
			return "love"
		} else if doesTitleContain(AppStrings.Icons.movie) {
			return "movie"
		} else if doesTitleContain(AppStrings.Icons.music) {
			return "music"
		} else if doesTitleContain(AppStrings.Icons.pencil) {
			return "pencil"
		} else if doesTitleContain(AppStrings.Icons.people) {
			return "people"
		} else if doesTitleContain(AppStrings.Icons.sleep) {
			return "sleep"
		} else if doesTitleContain(AppStrings.Icons.store) {
			return "store"
		} else if doesTitleContain(AppStrings.Icons.sun) {
			return "sun"
		} else if doesTitleContain(AppStrings.Icons.work) {
			return "work"
		} else { return nil }
	}
    
    func doesTitleContain(_ words: [String]) -> Bool {
        for word in words {
            if title.lowercased().contains(word) {
                return true
            }
        }
        
        return false
    }
    
    func generateEasterEggIcon() -> String? {
        if title == "smoke trees" {
            return "couch"
        } else if title == "get thicc" {
            return "gym"
        } else if title == "hang out with emma" {
            return "love"
        } else if title == "hang out with jahan" {
            return "code"
        } else {
            return nil
        }
    }
}

struct Block {
    
    let hour: Int
    var agendaItem: AgendaItem?
    var isEmpty: Bool {
        return agendaItem == nil
    }
    
    init(hour: Int, agendaItem: AgendaItem?) {
        self.hour = hour
        self.agendaItem = agendaItem
    }
}

enum Day: Int {
	case today = 0, tomorrow = 1
}
