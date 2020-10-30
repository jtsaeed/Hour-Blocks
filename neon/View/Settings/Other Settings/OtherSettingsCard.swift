//
//  OtherSettingsCard.swift
//  Hour Blocks
//
//  Created by James Saeed on 30/10/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

/// A Card based view allowing the user to choose from a set of options.
struct OtherSettingsCard: View {
    
    @Binding private var value: Int
    
    private let userPreference: UserPreference
    
    /// Creates an instance of OtherSettingsView.
    ///
    /// - Parameters:
    ///   - title: The user preference to display the information for and to change the setting for.
    ///   - value: The currently selected picker index.
    init(for userPreference: UserPreference, value: Binding<Int>) {
        self._value = value
        self.userPreference = userPreference
    }
    
    var body: some View {
        Card(padding: EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)) {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(userPreference.title)
                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                    Text(userPreference.description)
                        .font(.system(size: 17, weight: .regular, design: .default))
                        .opacity(0.6)
                        .fixedSize(horizontal: false, vertical: true)
                }
            
                Picker("", selection: $value) {
                    ForEach(0 ..< userPreference.options.count) { index in
                        Text(userPreference.options[index]).tag(index)
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }
        }.padding(.horizontal, 24)
        .onChange(of: value) { _ in refreshSchedule() }
    }
    
    /// Refreshes the schedule when a value has been changed.
    private func refreshSchedule() {
        NotificationCenter.default.post(name: Notification.Name(AppPublishers.Names.refreshSchedule), object: nil)
    }
}
