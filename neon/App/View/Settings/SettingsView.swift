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
                    SettingsCard(title: "Calendars",
                                 subtitle: "Take control of",
                                 iconName: "calendar_item",
                                 tapped: presentCalendars)
                    .sheet(isPresented: $isCalendarsPresented, content: {
                        CalendarSettingsView(isPresented: self.$isCalendarsPresented)
                            .environmentObject(self.viewModel)
                            .environmentObject(self.scheduleViewModel)
                    })
                    
                    SettingsCard(title: "Other Stuff",
                                 subtitle: "Take control of",
                                 iconName: "other_icon",
                                 tapped: presentOtherStuff)
                    .sheet(isPresented: $isOtherStuffPresented, content: {
                        OtherSettingsView(isPresented: self.$isOtherStuffPresented, timeFormatValue: self.viewModel.other[OtherSettingsKey.timeFormat.rawValue]!, reminderTimerValue: self.viewModel.other[OtherSettingsKey.reminderTimer.rawValue]!, autoCapsValue: self.viewModel.other[OtherSettingsKey.autoCaps.rawValue]!)
                            .environmentObject(self.viewModel)
                            .environmentObject(self.scheduleViewModel)
                    })
                    
                    SettingsCard(title: "Feedback",
                                 subtitle: "Provide valuable",
                                 iconName: "how_to_vote",
                                 tapped: presentFeedback)
                    .sheet(isPresented: $isFeedbackPresented) {
                        FeedbackView(isPresented: self.$isFeedbackPresented)
                    }
                    
                    SettingsCard(title: "Twitter",
                                 subtitle: "Follow me on",
                                 iconName: "twitter_icon",
                                 tapped: openTwitter)
                    
                    SettingsCard(title: "Privacy Policy",
                                 subtitle: "Take a look at the",
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
    func presentFeedback() { isFeedbackPresented = true }
    func presentPrivacyPolicy() { isPrivacyPolicyPresented = true }
}

private struct SettingsHeader: View {
    
    var body: some View {
        Header(title: "Settings", subtitle: "Hour Blocks \(DataGateway.shared.currentVersion)".uppercased()) {
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
