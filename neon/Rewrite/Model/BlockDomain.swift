//
//  BlockDomain.swift
//  neon
//
//  Created by James Saeed on 12/02/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import Foundation

enum BlockDomain: String, Domain, CaseIterable {
    
    case wake
    case read, book, quran
    case birthday
    case code
    case commute
    case home
    case shopping
    case store
    case movie
    case work
    case call
    case email
    case vote
    case write, draw
    case swim
    case tv
    case game
    case music, guitar, piano
    case paint
    case design
    case walk
    case morning
    case navigate
    case cycle
    case drive
    case run
    case bus
    case train
    case flight
    case love
    case relax
    case sleep, nap
    case party
    case coffee
    case laundry
    case meditate, yoga
    case eat, cook, breakfast, lunch, dinner
    case pets
    case exercise, gym
    case golf
    case competition
    case meeting
    case school, lecture, study, homework, exam
    case baseball, basketball, cricket, hockey, rugby, football, tennis, volleyball
    case winter
    
    var iconName: String {
        switch self {
        case .wake: return "alarm_clock"
        case .read, .book, .quran: return "menu_book"
        case .birthday: return "cake"
        case .code: return "code"
        case .commute: return "commute"
        case .home: return "home"
        case .shopping: return "shopping_cart"
        case .store: return "store"
        case .movie: return "theaters"
        case .work: return "work"
        case .call: return "call"
        case .email: return "email"
        case .vote: return "how_to_vote"
        case .write, .draw: return "create"
        case .swim: return "pool"
        case .tv: return "tv"
        case .game: return "sports_esports"
        case .music, .guitar, .piano: return "music_note"
        case .paint: return "brush"
        case .design: return "palette"
        case .walk: return "nature_people"
        case .morning: return "wb_sunny"
        case .navigate: return "location_on"
        case .cycle: return "directions_bike"
        case .drive: return "directions_car"
        case .run: return "directions_run"
        case .bus: return "directions_bus"
        case .train: return "directions_subway"
        case .flight: return "flight"
        case .love: return "favorite"
        case .relax: return "weekend"
        case .sleep, .nap: return "hotel"
        case .party: return "local_bar"
        case .coffee: return "local_cafe"
        case .laundry: return "local_laundry"
        case .meditate, .yoga: return "self_improvement"
        case .eat, .cook, .breakfast, .lunch, .dinner: return "restaurant"
        case .pets: return "pets"
        case .exercise, .gym: return "fitness_center"
        case .golf: return "golf_course"
        case .competition: return "emoji_events"
        case .meeting: return "group"
        case .school, .lecture, .study, .homework, .exam: return "school"
        case .baseball: return "sports_baseball"
        case .basketball: return "sports_basketball"
        case .cricket: return "sports_cricket"
        case .hockey: return "sports_hockey"
        case .rugby: return "sports_rugby"
        case .football: return "sports_soccer"
        case .tennis: return "sports_tennis"
        case .volleyball: return "sports_volleyball"
        case .winter: return "ac_unit"
        }
    }
    
    var suggestionTitle: String {
        switch self {
        case .wake: return "wake up"
        case .read: return "read"
        case .book: return "read book"
        case .quran: return "read quran"
        case .birthday: return "birthday"
        case .code: return "programming"
        case .commute: return "commute"
        case .home: return "go home"
        case .shopping: return "shopping"
        case .store: return "go to the store"
        case .movie: return "watch a movie"
        case .work: return "work"
        case .call: return "phone call"
        case .email: return "emails"
        case .vote: return "vote"
        case .write: return "write"
        case .draw: return "draw"
        case .swim: return "swimming"
        case .game: return "play games"
        case .tv: return "watch tv"
        case .music: return "music"
        case .guitar: return "guitar"
        case .piano: return "piano"
        case .paint: return "paint"
        case .design: return "design"
        case .walk: return "go for a walk"
        case .morning: return "morning routine"
        case .navigate: return "navigate"
        case .cycle: return "cycle"
        case .drive: return "drive"
        case .run: return "go for a run"
        case .bus: return "get the bus"
        case .train: return "get the train"
        case .flight: return "flight"
        case .love: return "time with loved ones"
        case .relax: return "relax"
        case .sleep: return "sleep"
        case .nap: return "have a nap"
        case .party: return "party"
        case .coffee: return "have a coffee"
        case .laundry: return "do laundry"
        case .meditate: return "meditate"
        case .yoga: return "yoga"
        case .eat: return "eat food"
        case .cook: return "cook food"
        case .breakfast: return "have breakfast"
        case .lunch: return "have lunch"
        case .dinner: return "have dinner"
        case .pets: return "play with pets"
        case .exercise: return "exercise"
        case .gym: return "go to the gym"
        case .golf: return "golf"
        case .competition: return "competition"
        case .meeting: return "meeting"
        case .school: return "school"
        case .lecture: return "lecture"
        case .study: return "study"
        case .homework: return "homework"
        case .exam: return "exam"
        case .baseball: return "baseball"
        case .basketball: return "basketball"
        case .cricket: return "cricket"
        case .hockey: return "hockey"
        case .rugby: return "rugby"
        case .football: return "football"
        case .tennis: return "tennis"
        case .volleyball: return "volleyball"
        case .winter: return "winter"
        }
    }
}

protocol Domain: Hashable {
    
    var iconName: String { get }
    var suggestionTitle: String { get }
}
