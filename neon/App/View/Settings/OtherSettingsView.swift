//
//  OtherSettingsView.swift
//  neon
//
//  Created by James Saeed on 30/10/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import SwiftUI
import EventKit

struct OtherSettingsView: View {
    
    @Binding var isPresented: Bool
    
    @EnvironmentObject var viewModel: SettingsViewModel
    @EnvironmentObject var scheduleViewModel: ScheduleViewModel
    
    @State var timeFormatValue: Int
    @State var reminderTimerValue: Int
    @State var autoCapsValue: Int
    
    var body: some View {
        NavigationView {
            List {
                OtherStuffCard(value: $timeFormatValue,
                               title: "Time Format",
                               description: "Change the time format used throughout Hour Blocks",
                               options: ["System", "12h", "24h"])
                OtherStuffCard(value: $reminderTimerValue,
                               title: "Reminder Timer",
                               description: "The length of time before a block's reminder comes through (doesn't change reminders already set)",
                               options: ["15m", "10m", "5m"])
                OtherStuffCard(value: $autoCapsValue,
                               title: "Autocapitalization",
                               description: "Would you like the titles of blocks to be automatically capitalised?",
                               options: ["Yes", "No"])
                if DataGateway.shared.isPro() && UIApplication.shared.supportsAlternateIcons {
                    IconChooserCard()
                }
            }
            .navigationBarItems(trailing: Button(action: {
                self.isPresented = false
            }, label: {
                Text("Done")
            }))
            .navigationBarTitle("Other Settings")
        }
        .accentColor(Color("primary"))
        .navigationViewStyle(StackNavigationViewStyle())
        .onDisappear {
            self.scheduleViewModel.reloadTodayBlocks()
            self.save()
        }
    }
    
    func save() {
        viewModel.other[OtherSettingsKey.timeFormat.rawValue] = timeFormatValue
        viewModel.other[OtherSettingsKey.reminderTimer.rawValue] = reminderTimerValue
        viewModel.other[OtherSettingsKey.autoCaps.rawValue] = autoCapsValue
    }
}

struct OtherStuffCard: View {
    
    @Binding var value: Int
    
    let title: String
    let description: String
    let options: [String]
    
    var body: some View {
        Card(cornerRadius: 24, shadowRadius: 6) {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(self.title)
                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                    Text(self.description)
                        .font(.system(size: 17, weight: .regular, design: .default))
                        .opacity(0.45)
                }
            
                Picker("", selection: self.$value) {
                    ForEach(0 ..< self.options.count) { index in
                        Text(self.options[index]).tag(index)
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }
        }
    }
}

struct IconChooserCard: View {
    
    @EnvironmentObject var viewModel: SettingsViewModel
    
    var body: some View {
        Card(cornerRadius: 24, shadowRadius: 6) {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("App Icon")
                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                    Text("Which Hour Blocks app icon would you like to be shown on your home screen?")
                        .font(.system(size: 17, weight: .regular, design: .default))
                        .opacity(0.45)
                }
                
                HStack(alignment: .center) {
                    Image("choose_original_icon")
                        .resizable()
                        .frame(width: 48, height: 48)
                        .cornerRadius(12)
                        .onTapGesture(perform: self.setOriginalIcon)
                    
                    Spacer()
                    
                    Image("choose_dark_icon")
                        .resizable()
                        .frame(width: 48, height: 48)
                        .cornerRadius(12)
                        .onTapGesture(perform: self.setDarkIcon)
                    
                    Spacer()
                    
                    Image("choose_pro_icon")
                        .resizable()
                        .frame(width: 48, height: 48)
                        .cornerRadius(12)
                        .onTapGesture(perform: self.setProIcon)
                }.padding(.horizontal, 8)
            }
        }
    }
    
    func setOriginalIcon() {
        HapticsGateway.shared.triggerAddBlockHaptic()
        viewModel.set(icon: .original)
    }
    
    func setDarkIcon() {
        HapticsGateway.shared.triggerLightImpact()
        viewModel.set(icon: .dark)
    }
    
    func setProIcon() {
        HapticsGateway.shared.triggerLightImpact()
        viewModel.set(icon: .pro)
    }
}
