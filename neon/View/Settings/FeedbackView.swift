//
//  FeedbackView.swift
//  Hour Blocks
//
//  Created by James Saeed on 28/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct FeedbackView: View {
    
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("Before submitting feedback, check out the roadmap to avoid submitting feedback that is already under consideration")
                    .font(.system(size: 17, weight: .semibold, design: .default))
                    .multilineTextAlignment(.center)
                
                ActionButton(title: "View Roadmap", action: openRoadmap)
                ActionButton(title: "Submit Feedback", action: openEmail)
            }.padding(.horizontal, 32)
            .navigationTitle("Feedback")
            .navigationBarItems(trailing: Button("Done", action: dismiss))
        }.accentColor(Color("AccentColor"))
    }
    
    func openRoadmap() {
        UIApplication.shared.open(URL(string: "https://www.notion.so/eledev/e1a79d17c1db49e29714ee7dad431fca?v=f6bfc7f5ee444c8cadc70d3730c21162")!)
    }
    
    func openEmail() {
        UIApplication.shared.open(URL(string: "mailto:support@jtsaeed.com")!)
    }
    
    func dismiss() {
        isPresented = false
    }
}

struct FeedbackView_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackView(isPresented: .constant(true))
    }
}
