//
//  NewOtherSettingsView.swift
//  Hour Blocks
//
//  Created by James Saeed on 22/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct OtherSettingsView: View {
    
    @Binding var isPresented: Bool
    
    @AppStorage("reminders") var remindersValue: Int = 0
    @AppStorage("dayStart") var dayStartValue: Int = 2
    @AppStorage("timeFormat") var timeFormatValue: Int = 1
    @AppStorage("autoCaps") var autoCapsValue: Int = 0
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    OtherSettingsCard(value: $remindersValue,
                                      title: "Reminders",
                                      description: "Enable reminders for upcoming Hour Blocks (changes only applied to new Hour Blocks)",
                                      options: ["On", "Off"])
                    OtherSettingsCard(value: $dayStartValue,
                                      title: "Day Start",
                                      description: "Change the time (am) your Schedule starts in Hour Blocks",
                                      options: ["12", "5", "6", "7", "8"])
                    OtherSettingsCard(value: $timeFormatValue,
                                      title: "Time Format",
                                      description: "Change the time format used throughout Hour Blocks",
                                      options: ["System", "12h", "24h"])
                    OtherSettingsCard(value: $autoCapsValue,
                                      title: "Automatic Capitalization",
                                      description: "Would you like the titles of blocks to be automatically capitalized?",
                                      options: ["Yes", "No"])
                    
                    if UIApplication.shared.supportsAlternateIcons {
                        IconChooserCard()
                    }
                }.padding(.top, 8)
                .padding(.bottom, 24)
            }.navigationBarTitle("Other Settings")
            .navigationBarItems(trailing: Button("Done", action: dismiss))
        }.accentColor(Color("AccentColor"))
    }
    
    func dismiss() {
        isPresented = false
    }
}

private struct OtherSettingsCard: View {
    
    @Binding var value: Int
    
    let title: String
    let description: String
    let options: [String]
    
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
        .onChange(of: value) { _ in
            NotificationCenter.default.post(name: Notification.Name("RefreshSchedule"), object: nil)
        }
    }
}

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
                    IconOption(iconName: "Original", internalIconName: "original") { setAlternateIcon(nil) }
                    IconOption(iconName: "Urgency", internalIconName: "urgency") { setAlternateIcon("icon_urgency") }
                    IconOption(iconName: "Blue", internalIconName: "blue") { setAlternateIcon("icon_blue") }
                    IconOption(iconName: "Purple", internalIconName: "purple") { setAlternateIcon("icon_purple") }
                    IconOption(iconName: "Night", internalIconName: "dark") { setAlternateIcon("icon_dark") }
                    IconOption(iconName: "Launched", internalIconName: "blueprint") { setAlternateIcon("icon_blueprint") }
                }
            }
        }.padding(.horizontal, 24)
    }
    
    func setAlternateIcon(_ iconName: String?) {
        HapticsGateway.shared.triggerAddBlockHaptic()
        UIApplication.shared.setAlternateIconName(iconName, completionHandler: nil)
    }
}

private struct IconOption: View {
    
    let iconName: String
    let internalIconName: String
    let onSelect: () -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Button(action: onSelect) {
                Image("choose_\(internalIconName)_icon")
                    .resizable()
                    .frame(width: 48, height: 48)
                    .cornerRadius(12)
            }
            Text(iconName)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .opacity(0.5)
        }
    }
}

struct OtherSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        OtherSettingsView(isPresented: .constant(true))
    }
}
