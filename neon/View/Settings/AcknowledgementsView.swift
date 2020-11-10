//
//  AcknowledgementsSheet.swift
//  Hour Blocks
//
//  Created by James Saeed on 11/08/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

/// A view displaying the acknowledgements for Hour Blocks.
struct AcknowledgementsView: View {
    
    @Binding private var isPresented: Bool
    
    /// Creates an instance of the AcknowledgementsView.
    ///
    /// - Parameters:
    ///   - isPresented: A binding determining whether or not the view is presented.
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                TextBlockView(title: AppStrings.Settings.iconsAcknowledgementTitle,
                              content: AppStrings.Settings.iconsAcknowledgementContent)
                TextBlockView(title: AppStrings.Settings.datesAcknowledgementTitle,
                              content: AppStrings.Settings.datesAcknowledgementContent)
                TextBlockView(title: AppStrings.Settings.testersAcknowledgementTitle,
                              content: AppStrings.Settings.testersAcknowledgementContent)
                Spacer()
            }.padding(.vertical, 24)
            .padding(.horizontal, 32)
            .navigationBarTitle(AppStrings.Settings.acknowledgementsTitle)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(AppStrings.Global.done, action: dismiss)
                }
            }
        }.accentColor(Color(AppStrings.Colors.accent))
    }
    
    /// Dismisses the current view.
    private func dismiss() {
        isPresented = false
    }
}

struct AcknowledgementsView_Previews: PreviewProvider {
    static var previews: some View {
        AcknowledgementsView(isPresented: .constant(true))
    }
}
