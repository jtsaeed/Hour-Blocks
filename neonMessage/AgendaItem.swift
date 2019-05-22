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
			if let icon = generateMLIcon() {
				self.icon = icon
			}
		} else {
			if let icon = generateLegacyIcon() {
				self.icon = icon
			}
		}
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
		if doesTitleContain(["draw", "paint", "art"]) {
			return "brush"
		} else if doesTitleContain(["develop", "code", "coding", "programming", "software"]) {
			return "code"
		} else if doesTitleContain(["commute", "commuting", "drive", "driving", "journey", "travel"]) {
			return "commute"
		} else if doesTitleContain(["relax", "chill"]) {
			return "couch"
		} else if doesTitleContain(["study", "lecture", "school", "read", "research", "revise", "revision"]) {
			return "education"
		} else if doesTitleContain(["breakfast", "lunch", "dinner", "food", "meal", "eat", "snack", "brunch"]) {
			return "food"
		} else if doesTitleContain(["game", "play", "arcade"]) {
			return "game"
		} else if doesTitleContain(["gym", "exercise", "run"]) {
			return "gym"
		} else if doesTitleContain(["date", "romantic", "boyfriend", "girlfriend", "husband", "wife", "family"]) {
			return "love"
		} else if doesTitleContain(["movie", "film", "cinema"]) {
			return "movie"
		} else if doesTitleContain(["music", "concert", "gig"]) {
			return "music"
		} else if doesTitleContain(["write", "writing"]) {
			return "pencil"
		} else if doesTitleContain(["party", "friend"]) {
			return "people"
		} else if doesTitleContain(["sleep", "bed", "nap", "rest"]) {
			return "sleep"
		} else if doesTitleContain(["shop", "shopping", "store"]) {
			return "store"
		} else if doesTitleContain(["morning", "beach", "park"]) {
			return "sun"
		} else if doesTitleContain(["work", "meeting", "assignment", "project"]) {
			return "work"
		} else {
			return nil
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
