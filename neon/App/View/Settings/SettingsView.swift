//
//  SettingsView.swift
//  neon3
//
//  Created by James Saeed on 18/06/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var viewModel: SettingsViewModel
    @EnvironmentObject var scheduleViewModel: ScheduleViewModel
    
    @State var isCalendarsPresented = false
    @State var isOtherStuffPresented = false
    @State var isFeedbackPresented = false
    @State var isPrivacyPolicyPresented = false
    
    var body: some View {
        NavigationView {
            VStack {
                SettingsHeader()
                List {
                    SettingsCard(title: NSLocalizedString("Calendars", comment: ""),
                                 subtitle: NSLocalizedString("Take control of", comment: ""),
                                 iconName: "calendar_item",
                                 tapped: presentCalendars)
                    .sheet(isPresented: $isCalendarsPresented, content: {
                        CalendarSettingsView(isPresented: self.$isCalendarsPresented)
                            .environmentObject(self.viewModel)
                            .environmentObject(self.scheduleViewModel)
                    })
                    
                    SettingsCard(title: NSLocalizedString("Other Stuff", comment: ""),
                                 subtitle: NSLocalizedString("Take control of", comment: ""),
                                 iconName: "other_icon",
                                 tapped: presentOtherStuff)
                    .sheet(isPresented: $isOtherStuffPresented, content: {
                        OtherSettingsView(isPresented: self.$isOtherStuffPresented,
                                          timeFormatValue: self.viewModel.other.timeFormat,
                                          reminderTimerValue: self.viewModel.other.reminderTimer,
                                          autoCapsValue: self.viewModel.other.autoCaps,
                                          dayStartValue: self.viewModel.other.dayStart)
                            .environmentObject(self.viewModel)
                            .environmentObject(self.scheduleViewModel)
                    })
                    
                    SettingsCard(title: "Twitter",
                                 subtitle: NSLocalizedString("Follow me on", comment: ""),
                                 iconName: "twitter_icon",
                                 tapped: openTwitter)
                    
                    SettingsCard(title: NSLocalizedString("Privacy Policy", comment: ""),
                                 subtitle: NSLocalizedString("Take a look at the", comment: ""),
                                 iconName: "privacy_icon",
                                 tapped: presentPrivacyPolicy)
                    .sheet(isPresented: $isPrivacyPolicyPresented, content: {
                        PrivacyPolicyView(isPresented: self.$isPrivacyPolicyPresented)
                    })
                }
            }
            .navigationBarTitle("Settings")
            .navigationBarHidden(true)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    func openTwitter() {
        if let url = URL(string: "https://twitter.com/j_t_saeed") {
            UIApplication.shared.open(url)
        }
    }
    
    func presentCalendars() { isCalendarsPresented = true }
    func presentOtherStuff() { isOtherStuffPresented = true }
    func presentPrivacyPolicy() { isPrivacyPolicyPresented = true }
}

private struct SettingsHeader: View {
    
    var body: some View {
        Header(title: NSLocalizedString("Settings", comment: ""),
               subtitle: "Hour Blocks \(DataGateway.shared.fullCurrentVersion)".uppercased()) {
            EmptyView()
        }
    }
}

struct SettingsCard: View {
    
    let title: String
    let subtitle: String
    let iconName: String
    let tapped: () -> Void
    
    var body: some View {
        Card {
            HStack {
                CardLabels(title: self.title,
                           subtitle: self.subtitle.uppercased())
                Spacer()
                IconButton(iconName: self.iconName,
                           action: self.tapped)
            }
        }
    }
}

struct SettingsView_Previews : PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
