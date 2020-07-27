//
//  NewSettingsView.swift
//  Hour Blocks
//
//  Created by James Saeed on 07/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct NewSettingsView: View {
    
    @StateObject var viewModel = NewSettingsViewModel()
    
    var body: some View {
        VStack {
            NewHeaderView(title: "Settings", subtitle: "Hour Blocks 6.0 Beta 1") { EmptyView() }
            
            ScrollView {
                VStack(spacing: 24) {
                    SettingsCardView(title: "Feedback",
                                     subtitle: "Provide valuable",
                                     iconName: "text.bubble.fill",
                                     action: viewModel.presentFeedbackView)
                    
                    SettingsCardView(title: "Calendars",
                                     subtitle: "Take control of",
                                     iconName: "calendar",
                                     action: viewModel.presentCalendarOptionsView)
                    .sheet(isPresented: $viewModel.isCalendarOptionsViewPresented) {
                        NewCalendarOptionsView(isPresented: $viewModel.isCalendarOptionsViewPresented)
                    }
                    
                    SettingsCardView(title: "Other Stuff",
                                     subtitle: "Take control of",
                                     iconName: "gearshape.fill",
                                     action: viewModel.presentOtherSettingsView)
                    .sheet(isPresented: $viewModel.isOtherSettingsViewPresented) {
                        NewOtherSettingsView()
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

struct NewSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NewSettingsView()
    }
}