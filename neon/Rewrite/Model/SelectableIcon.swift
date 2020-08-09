//
//  SelectableIcon.swift
//  Hour Blocks
//
//  Created by James Saeed on 09/08/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import Foundation

enum SelectableIcon: String, CorrespondableImage, Hashable, CaseIterable {
    
    case baseball, basketball, bed, blocks, book, brush, bus, car, clock, code, coffee, cricket, drink, flower, food, football, golf, gym, hockey, house, laundry, mail, movie, music, nature, palette, pencil, people, phone, plane, rugby, run, school, shopping, sun, swim, tennis, train, transport, trophy, tv, volleyball, vote, water, work
    
    var imageName: String {
        switch self {
        case .baseball: return "sports_baseball"
        case .basketball: return "sports_basketball"
        case .bed: return "hotel"
        case .blocks: return "default"
        case .book: return "chrome_reader"
        case .brush: return "brush"
        case .bus: return "directions_bus"
        case .car: return "directions_car"
        case .clock: return "alarm_clock"
        case .code: return "code"
        case .coffee: return "local_cafe"
        case .cricket: return "sports_cricket"
        case .drink: return "local_bar"
        case .flower: return "local_florist"
        case .food: return "restaurant"
        case .football: return "sports_soccer"
        case .golf: return "golf_course"
        case .gym: return "fitness_center"
        case .hockey: return "sports_hockey"
        case .house: return "home"
        case .laundry: return "local_laundry"
        case .mail: return "email"
        case .movie: return "theaters"
        case .music: return "music_note"
        case .nature: return "nature_people"
        case .palette: return "palette"
        case .pencil: return "create"
        case .people: return "group"
        case .phone: return "call"
        case .plane: return "flight"
        case .rugby: return "sports_rugby"
        case .run: return "directions_run"
        case .school: return "school"
        case .shopping: return "shopping_cart"
        case .sun: return "wb_sunny"
        case .swim: return "pool"
        case .tennis: return "sports_tennis"
        case .train: return "directions_subway"
        case .transport: return "commute"
        case .trophy: return "emoji_events"
        case .tv: return "tv"
        case .volleyball: return "sports_volleyball"
        case .vote: return "how_to_vote"
        case .water: return "waves"
        case .work: return "work"
        default: return "default"
        }
    }
}

private protocol CorrespondableImage {
    
    var imageName: String { get }
}
