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
    @AppStorage("reminders") private var remindersValue: Int = 0
    /// A UserDefaults property determining what time the schedule starts.
    @AppStorage("dayStart") private var dayStartValue: Int = 2
    /// A UserDefaults property determining what hour format to use when displaying times.
    @AppStorage("timeFormat") private var timeFormatValue: Int = 1
    /// A UserDefaults property determining whether or not to automatically capitalize Hour Blocks and To Do items.
    @AppStorage("autoCaps") private var autoCapsValue: Int = 0
    
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
                    OtherSettingsCard(title: "Reminders",
                                      description: "Enable reminders for upcoming Hour Blocks (changes only applied to new Hour Blocks)",
                                      options: ["On", "Off"],
                                      value: $remindersValue)
                    OtherSettingsCard(title: "Day Start",
                                      description: "Change the time (am) your Schedule starts in Hour Blocks",
                                      options: ["12", "5", "6", "7", "8"],
                                      value: $dayStartValue)
                    OtherSettingsCard(title: "Time Format",
                                      description: "Change the time format used throughout Hour Blocks",
                                      options: ["System", "12h", "24h"],
                                      value: $timeFormatValue)
                    OtherSettingsCard(title: "Automatic Capitalization",
                                      description: "Would you like the titles of blocks to be automatically capitalized?",
                                      options: ["Yes", "No"],
                                      value: $autoCapsValue)
                    
                    if UIApplication.shared.supportsAlternateIcons {
                        IconChooserCard()
                    }
                }.padding(.top, 8)
                .padding(.bottom, 24)
            }.navigationBarTitle("Other Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done", action: dismiss)
                }
            }
        }.accentColor(Color("AccentColor"))
    }
    
    /// Dismisses the current view.
    private func dismiss() {
        isPresented = false
    }
}

/// A Card based view allowing the user to choose from a set of options.
private struct OtherSettingsCard: View {
    
    @Binding private var value: Int
    
    private let title: String
    private let description: String
    private let options: [String]
    
    /// Creates an instance of OtherSettingsView.
    ///
    /// - Parameters:
    ///   - title: The text string for the header label at the top.
    ///   - description: The text string for the description label below the header.
    ///   - options: An array of strings of the picker options to be displayed at the bottom.
    ///   - value: The currently selected picker index.
    init(title: String, description: String, options: [String], value: Binding<Int>) {
        self._value = value
        self.title = title
        self.description = description
        self.options = options
    }
    
    var body: some View {
        Card(padding: EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)) {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                    Text(description)
                        .font(.system(size: 17, weight: .regular, design: .default))
                        .opacity(0.6)
                        .fixedSize(horizontal: false, vertical: true)
                }
            
                Picker("", selection: $value) {
                    ForEach(0 ..< options.count) { index in
                        Text(options[index]).tag(index)
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }
        }.padding(.horizontal, 24)
        .onChange(of: value) { _ in refreshSchedule() }
    }
    
    /// Refreshes the schedule when a value has been changed.
    private func refreshSchedule() {
        NotificationCenter.default.post(name: Notification.Name("RefreshSchedule"), object: nil)
    }
}

/// A Card based view allowing the user to choose from a set of app icons.
private struct IconChooserCard: View {
    
    var body: some View {
        Card {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("App Icon")
                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                    Text("Which Hour Blocks app icon would you like to be shown on your home screen?")
                        .font(.system(size: 17, weight: .regular, design: .default))
                        .opacity(0.6)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 72, maximum: 112))], spacing: 24) {
                    IconOption(label: "Original", iconName: "original")
                    IconOption(label: "Urgency", iconName: "urgency")
                    IconOption(label: "Blue", iconName: "blue")
                    IconOption(label: "Purple", iconName: "purple")
                    IconOption(label: "Night", iconName: "dark")
                    IconOption(label: "Launched", iconName: "blueprint")
                }
            }
        }.padding(.horizontal, 24)
    }
}

/// A tile view for a selectable icon.
private struct IconOption: View {
    
    private let label: String
    private let iconName: String
    
    /// Creates an instance of the IconOption view.
    ///
    /// - Parameters:
    ///   - label: The text string for the label at the bottom of the tile.
    ///   - iconName: The internal icon name.
    init(label: String, iconName: String) {
        self.label = label
        self.iconName = iconName
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Button(action: setIcon) {
                Image("choose_\(iconName)_icon")
                    .resizable()
                    .frame(width: 48, height: 48)
                    .cornerRadius(12)
            }
            Text(label)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .opacity(0.5)
        }
    }
    
    /// Sets the icon when the tile gets tapped.
    private func setIcon() {
        HapticsGateway.shared.triggerAddBlockHaptic()
        
        let iconFileName = iconName == "original" ? nil : "icon_\(iconName)"
        UIApplication.shared.setAlternateIconName(iconFileName, completionHandler: nil)
    }
}

struct OtherSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        OtherSettingsView(isPresented: .constant(true))
    }
}
