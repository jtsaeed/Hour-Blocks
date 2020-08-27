//
//  SelectableIcon.swift
//  Hour Blocks
//
//  Created by James Saeed on 09/08/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import Foundation

enum SelectableIcon: String, CorrespondableImage, Hashable, CaseIterable {
    
    case baseball, basketball, bed, bike, blocks, book, brush, bus, cake, car, clock, code, coffee, couch, cricket, drink, food, football, gamepad, golf, gym, heart, hockey, house, laundry, location, mail, meditate, movie, music, nature, palette, paw, pencil, people, phone, plane, rugby, run, school, shopping, sun, swim, tennis, train, transport, trophy, tv, volleyball, vote, winter, work
    
    var imageName: String {
        switch self {
        case .baseball: return "sports_baseball"
        case .basketball: return "sports_basketball"
        case .bed: return "hotel"
        case .bike: return "directions_bike"
        case .blocks: return "default"
        case .book: return "menu_book"
        case .brush: return "brush"
        case .bus: return "directions_bus"
        case .cake: return "cake"
        case .car: return "directions_car"
        case .clock: return "alarm"
        case .code: return "code"
        case .coffee: return "local_cafe"
        case .couch: return "weekend"
        case .cricket: return "sports_cricket"
        case .drink: return "local_bar"
        case .food: return "restaurant"
        case .football: return "sports_soccer"
        case .gamepad: return "sports_esports"
        case .golf: return "golf_course"
        case .gym: return "fitness_center"
        case .heart: return "favorite"
        case .hockey: return "sports_hockey"
        case .house: return "home"
        case .laundry: return "local_laundry"
        case .location: return "location_on"
        case .mail: return "email"
        case .meditate: return "self_improvement"
        case .movie: return "theaters"
        case .music: return "music_note"
        case .nature: return "nature_people"
        case .palette: return "palette"
        case .paw: return "pets"
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
        case .winter: return "ac_unit"
        case .work: return "work"
        }
    }
}

private protocol CorrespondableImage {
    
    var imageName: String { get }
}
