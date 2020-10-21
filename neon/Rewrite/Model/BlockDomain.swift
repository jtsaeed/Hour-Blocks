//
//  BlockDomain.swift
//  neon
//
//  Created by James Saeed on 12/02/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import Foundation

/// An enum dictating the 'category' of an Hour Block in the form of a 'domain'; similar to SiriKit's domains.
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
    
    /// The corresponding icon for a domain.
    var icon: SelectableIcon {
        switch self {
        case .wake: return .clock
        case .read, .book, .quran: return .book
        case .birthday: return .cake
        case .code: return .code
        case .commute: return .transport
        case .home: return .house
        case .shopping: return .shopping
        case .store: return .shopping
        case .movie: return .movie
        case .work: return .work
        case .call: return .phone
        case .email: return .mail
        case .vote: return .vote
        case .write, .draw: return .pencil
        case .swim: return .swim
        case .tv: return .tv
        case .game: return .gamepad
        case .music, .guitar, .piano: return .music
        case .paint: return .brush
        case .design: return .palette
        case .walk: return .nature
        case .morning: return .sun
        case .navigate: return .location
        case .cycle: return .bike
        case .drive: return .car
        case .run: return .run
        case .bus: return .bus
        case .train: return .train
        case .flight: return .plane
        case .love: return .heart
        case .relax: return .couch
        case .sleep, .nap: return .bed
        case .party: return .drink
        case .coffee: return .coffee
        case .laundry: return .laundry
        case .meditate, .yoga: return .meditate
        case .eat, .cook, .breakfast, .lunch, .dinner: return .food
        case .pets: return .paw
        case .exercise, .gym: return .gym
        case .golf: return .golf
        case .competition: return .trophy
        case .meeting: return .people
        case .school, .lecture, .study, .homework, .exam: return .school
        case .baseball: return .baseball
        case .basketball: return .basketball
        case .cricket: return .cricket
        case .hockey: return .hockey
        case .rugby: return .rugby
        case .football: return .football
        case .tennis: return .tennis
        case .volleyball: return .volleyball
        case .winter: return .winter
        }
    }
    
    /// The corrresponding title to be shown when the domain is used as a suggested Hour Block.
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
    
    var icon: SelectableIcon { get }
    var suggestionTitle: String { get }
}
