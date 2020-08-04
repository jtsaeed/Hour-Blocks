//
//  NewSettingsView.swift
//  Hour Blocks
//
//  Created by James Saeed on 07/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject var viewModel = SettingsViewModel()
    
    var body: some View {
        VStack {
            HeaderView(title: "Settings", subtitle: "Hour Blocks \(VersionGateway.shared.fullCurrentVersion)") {
                EmptyView()
            }
            
            ScrollView {
                VStack(spacing: 24) {
                    SettingsCardView(title: "Feedback",
                                     subtitle: "Provide valuable",
                                     iconName: "text.bubble.fill",
                                     action: viewModel.presentFeedbackView)
                    .sheet(isPresented: $viewModel.isFeedbackViewPresented, content: {
                        FeedbackView(isPresented: $viewModel.isFeedbackViewPresented)
                    })
                    
                    SettingsCardView(title: "Calendars",
                                     subtitle: "Take control of",
                                     iconName: "calendar",
                                     action: viewModel.presentCalendarOptionsView)
                    .sheet(isPresented: $viewModel.isCalendarOptionsViewPresented) {
                        CalendarOptionsView(isPresented: $viewModel.isCalendarOptionsViewPresented)
                    }
                    
                    SettingsCardView(title: "Other Stuff",
                                     subtitle: "Take control of",
                                     iconName: "gearshape.fill",
                                     action: viewModel.presentOtherSettingsView)
                    .sheet(isPresented: $viewModel.isOtherSettingsViewPresented) {
                        OtherSettingsView()
                    }
                    
                    SettingsCardView(title: "Twitter",
                                     subtitle: "Follow me on",
                                     iconName: "person.fill",
                                     action: viewModel.openTwitter)
                    
                    SettingsCardView(title: "Privacy Policy",
                                     subtitle: "Take a look at the",
                                     iconName: "lock.fill",
                                     action: viewModel.presentPrivacyPolicyView)
                    .sheet(isPresented: $viewModel.isPrivacyPolicyPresented) {
                        PrivacyPolicyView(isPresented: $viewModel.isPrivacyPolicyPresented)
                    }
                }.padding(.top, 8)
                .padding(.bottom, 24)
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
