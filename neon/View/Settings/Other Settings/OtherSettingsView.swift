//
//  NewOtherSettingsView.swift
//  Hour Blocks
//
//  Created by James Saeed on 22/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

/// A view displaying all of the miscellaneous settings.
struct OtherSettingsView: View {
    
    @Binding private var isPresented: Bool
    
    /// A UserDefaults property determining whether or not a reminder should be set with the creation of an Hour Block.
    @AppStorage(UserPreference.reminders.key) private var remindersValue: Int = UserPreference.reminders.defaultValue
    /// A UserDefaults property determining what time the schedule starts.
    @AppStorage(UserPreference.dayStart.key) private var dayStartValue: Int = UserPreference.dayStart.defaultValue
    /// A UserDefaults property determining what hour format to use when displaying times.
    @AppStorage(UserPreference.timeFormat.key) private var timeFormatValue: Int = UserPreference.timeFormat.defaultValue
    /// A UserDefaults property determining whether or not to automatically capitalize Hour Blocks and To Do items.
    @AppStorage(UserPreference.autoCaps.key) private var autoCapsValue: Int = UserPreference.autoCaps.defaultValue
    
    /// Creates an instance of OtherSettingsView.
    ///
    /// - Parameters:
    ///   - isPresented: A binding determining whether or not the view is presented.
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    OtherSettingsCard(for: UserPreference.reminders,
                                      value: $remindersValue)
                    OtherSettingsCard(for: UserPreference.dayStart,
                                      value: $dayStartValue)
                    OtherSettingsCard(for: UserPreference.timeFormat,
                                      value: $timeFormatValue)
                    OtherSettingsCard(for: UserPreference.autoCaps,
                                      value: $autoCapsValue)
                    
                    if UIApplication.shared.supportsAlternateIcons {
                        IconChooserCard()
                    }
                }.padding(.top, 8)
                .padding(.bottom, 24)
            }.navigationBarTitle(AppStrings.Settings.otherTitle)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(AppStrings.Global.done, action: dismiss)
                }
            }
        }.accentColor(Color(AppStrings.Colors.accent))
    }
    
    /// Dismisses the current view.
    private func dismiss() {
        isPresented = false
    }
}

struct OtherSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        OtherSettingsView(isPresented: .constant(true))
    }
}
