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
    @AppStorage("timeFormat") var timeFormatValue: Int = 1
    @AppStorage("autoCaps") var autoCapsValue: Int = 0
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    OtherSettingsCard(value: $remindersValue,
                                      title: "Reminders",
                                      description: "Enable reminders for upcoming Hour Blocks",
                                      options: ["On", "Off"])
                    OtherSettingsCard(value: $timeFormatValue,
                                      title: "Time Format",
                                      description: "Change the time format used throughout Hour Blocks",
                                      options: ["System", "12h", "24h"])
                    /*
                    OtherSettingsCard(value: $autoCapsValue,
                                      title: "Autocapitalization",
                                      description: "Would you like the titles of blocks to be automatically capitalized?",
                                      options: ["Yes", "No"])
                     */
                    IconChooserCard()
                }.padding(.top, 8)
                .padding(.bottom, 24)
            }
            .navigationBarItems(trailing: Button("Done", action: dismiss))
            .navigationBarTitle("Other Settings")
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
        Card {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                    Text(description)
                        .font(.system(size: 17, weight: .regular, design: .default))
                        .opacity(0.6)
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
                }
                
                HStack(alignment: .center) {
                    IconOption(iconName: "original", onSelect: setOriginalIcon)
                    Spacer()
                    IconOption(iconName: "dark", onSelect: setDarkIcon)
                    Spacer()
                    IconOption(iconName: "blueprint", onSelect: setBlueprintIcon)
                }.padding(.horizontal, 8)
            }
        }.padding(.horizontal, 24)
    }
    
    func setOriginalIcon() {
        HapticsGateway.shared.triggerAddBlockHaptic()
        UIApplication.shared.setAlternateIconName(nil, completionHandler: nil)
    }
    
    func setDarkIcon() {
        HapticsGateway.shared.triggerLightImpact()
        UIApplication.shared.setAlternateIconName("icon_dark", completionHandler: nil)
    }
    
    func setBlueprintIcon() {
        HapticsGateway.shared.triggerLightImpact()
        UIApplication.shared.setAlternateIconName("icon_blueprint", completionHandler: nil)
    }
}

private struct IconOption: View {
    
    let iconName: String
    let onSelect: () -> Void
    
    var body: some View {
        Image("choose_\(iconName)_icon")
            .resizable()
            .frame(width: 48, height: 48)
            .cornerRadius(12)
            .onTapGesture(perform: onSelect)
    }
}

struct OtherSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        OtherSettingsView(isPresented: .constant(true))
    }
}
