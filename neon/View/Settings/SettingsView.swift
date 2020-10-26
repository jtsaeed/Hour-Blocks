//
//  NewSettingsView.swift
//  Hour Blocks
//
//  Created by James Saeed on 07/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

/// The root view of the Settings tab
struct SettingsView: View {
    
    @StateObject var viewModel = SettingsViewModel()
    
    var body: some View {
        VStack {
            HeaderView(title: AppStrings.Settings.header, subtitle: AppStrings.Settings.appVersion) {
                EmptyView()
            }
            
            CardsListView {
                // MARK: - Calendars
                SettingsCardView(title: AppStrings.Settings.calendarsTitle,
                                 subtitle: AppStrings.Settings.calendarsSubtitle,
                                 iconName: AppStrings.Icons.calendar,
                                 action: viewModel.presentCalendarSettingsView)
                .sheet(isPresented: $viewModel.isCalendarSettingsViewPresented) {
                    CalendarSettingsView(isPresented: $viewModel.isCalendarSettingsViewPresented)
                }
                
                // MARK: - Other Stuff
                SettingsCardView(title: AppStrings.Settings.otherTitle,
                                 subtitle: AppStrings.Settings.otherSubtitle,
                                 iconName: AppStrings.Icons.gear,
                                 action: viewModel.presentOtherSettingsView)
                .sheet(isPresented: $viewModel.isOtherSettingsViewPresented) {
                    OtherSettingsView(isPresented: $viewModel.isOtherSettingsViewPresented)
                }
                
                // MARK: - Twitter Feedback
                SettingsCardView(title: AppStrings.Settings.feedbackTitle,
                                 subtitle: AppStrings.Settings.feedbackSubtitle,
                                 iconName: AppStrings.Icons.feedback,
                                 action: viewModel.openTwitter)
                
                // MARK: - Privacy Policy
                SettingsCardView(title: AppStrings.Settings.privacyTitle,
                                 subtitle: AppStrings.Settings.privacySubtitle,
                                 iconName: AppStrings.Icons.privacy,
                                 action: viewModel.presentPrivacyPolicyView)
                .sheet(isPresented: $viewModel.isPrivacyPolicyViewPresented) {
                    PrivacyPolicyView(isPresented: $viewModel.isPrivacyPolicyViewPresented)
                }
                
                // MARK: - Acknowledgements
                SettingsCardView(title: AppStrings.Settings.acknowledgementsTitle,
                                 subtitle: AppStrings.Settings.acknowledgementsSubtitle,
                                 iconName: AppStrings.Icons.star,
                                 action: viewModel.presentAcknowledgementsView)
                .sheet(isPresented: $viewModel.isAcknowledgementsViewPresented) {
                    AcknowledgementsView(isPresented: $viewModel.isAcknowledgementsViewPresented)
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
