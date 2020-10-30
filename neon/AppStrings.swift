//
//  AppStrings.swift
//  Hour Blocks
//
//  Created by James Saeed on 26/10/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import Foundation

/// A structure containing static strings used throughout the app.
struct AppStrings {
    
    struct Colors {
        static let accent = "AccentColor"
        static let confirmation = "ConfirmColor"
        static let urgent = "UrgentColor"
        
        static let background = "BackgroundColor"
        static let text = "TextColor"
        static let divider = "DividerColor"
        
        static let cardBacking = "CardBackingColor"
        static let cardShadow = "CardShadowColor"
        
        static let hourBlockIcon = "HourBlockIconColor"
    }
    
    struct Icons {
        static let add = "plus"
        static let edit = "pencil"
        static let undo = "arrow.uturn.left"
        static let copy = "plus.square.on.square"
        static let clear = "trash"
        
        static let checkmark = "checkmark"
        static let subBlocks = "rectangle.grid.1x2"
        static let reschedule = "calendar.badge.clock"
        static let addToSchedule = "calendar.badge.plus"
        static let swap = "arrow.up.arrow.down"
        static let below = "arrow.turn.left.down"
        static let above = "arrow.turn.left.up"
        static let calendar = "calendar"
        static let history = "clock"
        static let gear = "gearshape.fill"
        static let feedback = "text.bubble.fill"
        static let privacy = "lock.fill"
        static let star = "star.fill"
        
        static let calendarEvent = "event"
    }
    
    struct AppStorage {
        static let timeFormat = "timeFormat"
    }
    
    struct Global {
        static let save = "Save"
        static let done = "Done"
        static let cancel = "Cancel"
        static let clear = "Clear"
        
        static let textFieldPlaceholder = "Enter the title here..."
    }
    
    struct Schedule {
        static let header = "Schedule"
        static let datePickerHeader = "Date Picker"
        
        struct HourBlock {
            static let empty = "Empty"
            
            static let addHeader = "Add an Hour Block"
            static let editHeader = "Edit Hour Block"
            static let subBlocksHeader = "Sub Blocks"
            static let rescheduleHeader = "Reschedule Block"
            static let duplicateHeader = "Duplicate Hour Block"
            static let suggestionsHeader = "Suggestions"
            
            static let menuEdit = "Edit"
            static let menuSubBlocks = "Sub Blocks"
            static let menuReschedule = "Reschedule"
            static let menuDuplicate = "Duplicate"
            
            static let clearAlertTitle = "Clear Hour Block"
            static let clearAlertText = "Are you sure you would like to clear this Hour Block? This will also clear any Sub Blocks within the Hour Block"
            
            static let overwriteAlertTitle = "Overwrite Existing Hour Block"
            static let overwriteAlertText = "Are you sure you would like to overwrite an existing Hour Block? This will also clear any Sub Blocks within the Hour Block"
            static let overwriteAlertButton = "Overwrite"
            
            static let noHourBlocksTitle = "Hour Blocks"
            static let noHourBlocksSubtitle = "No"
            
            static let noSuggestionsTitle = "None"
            static let noSuggestionsSubtitle = "Currently"
            
            static let calendarBlockAllDay = "ALL DAY"
        }
    }
    
    struct ToDoList {
        static let header = "To Do List"
        static let addHeader = "Add a To Do Item"
        static let historyHeader = "History"
        
        static func itemsCount(count: Int) -> String { return "\(count) Item\(count == 1 ? "" : "s")" }
        
        struct ToDoItem {
            static let urgency = "Urgency"
            static let editHeader = "Edit To Do Item"
            static let addToTodayHeader = "Add to Today"
            
            static let menuComplete = "Complete"
            static let menuEdit = "Edit"
            static let menuAddToToday = "Add to Today"
            static let menuClear = "Clear"
        }
    }
    
    struct Settings {
        static let header = "Settings"
        static let appVersion = "Hour Blocks \(VersionGateway.shared.currentFullVersion)"
        
        static let calendarsTitle = "Calendars"
        static let calendarsSubtitle = "Take control of"
        static let otherTitle = "Other stuff"
        static let otherSubtitle = "Take control of"
        static let feedbackTitle = "Twitter"
        static let feedbackSubtitle = "Provide feedback on"
        static let privacyTitle = "Privacy Policy"
        static let privacySubtitle = "Take a look at the"
        static let acknowledgementsTitle = "Acknowledgements"
        static let acknowledgementsSubtitle = "Take a look at the"
        
        static let appIconChooserTitle = "App Icon"
        static let appIconChooserContent = "Which Hour Blocks app icon would you like to be shown on your home screen?"
        
        static let noCalendarAccess = "Calendar access hasn't been granted"
        
        static let personalDataPrivacyTitle = "Your personal data is safe 🔐"
        static let personalDataPrivacyContent = "Personal identifiers such as name and phone number aren't even asked for by Hour Blocks- we simply don't need that from you"
        static let collectedDataPrivacyTitle = "So what do we collect? 🤔"
        static let collectedDataPrivacyContent = "In order to improve certain aspects of Hour Blocks such as icon generation and suggestions, we collect just simply the 'category' of a block you add- and it's completely anonymized, so it can't be traced back to you"
        static let viewFullPrivacyPolicyButton = "View full privacy policy"
        static let fullPrivacyPolicyURL = "https://app.termly.io/document/privacy-policy/0a585245-4a5e-415c-af29-adf25c1b031c"
        
        static let iconsAcknowledgementTitle = "Icons 🖼"
        static let iconsAcknowledgementContent = "Hour Blocks uses Material Design Icons by Google for its block icons"
        static let datesAcknowledgementTitle = "Date Manipulation 🗓"
        static let datesAcknowledgementContent = "Hour Blocks uses the SwiftDate library for a lot of its date manipulation work"
        static let testersAcknowledgementTitle = "Beta Testers 🐞"
        static let testersAcknowlegdementContent = "A big thank you to everyone who has beta tested and provided feedback for Hour Blocks!"
    }
    
    struct WhatsNew {
        static let header = "What's new in\nHour Blocks \(VersionGateway.shared.currentFullVersion)"
        
        static let dismissButtonTitle = "Let's go!"
    }
}
