//
//  ProPurchaseView.swift
//  neon
//
//  Created by James Saeed on 06/12/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import SwiftUI
import SwiftyStoreKit

struct ProPurchaseView: View {
    
    @Binding var showPurchasePro: Bool
    
    @State var isLoading: Bool = false
    @State var showErrorAlert: Bool = false
    @State var errorAlertText: String = "Unfortunately your request for Hour Blocks Pro could not be processed"
    
    var body: some View {
        VStack {
            WhatsNewHeader(title: "Hour Blocks Pro")
                .padding(.vertical, 40)
            
            VStack(alignment: .leading, spacing: 16) {
                WhatsNewItem(title: "Sub Blocks 💪",
                             content: "Add as many Sub Blocks as you want to an Hour Block for maximum productivity")
                WhatsNewItem(title: "Unlimited Habits 🔥",
                             content: "Break the 3 habits limit and keep those streaks going for an unlimited amount of habits")
                WhatsNewItem(title: "Alternate App Icons 🎨",
                             content: "Choose from 3 different app icons to display on your homescreen")
            }
            
            Spacer()
            
            if !isLoading {
                ActionButton(title: "Let's go Pro!", color: Color("secondary"))
                    .onTapGesture {
                        HapticsGateway.shared.triggerLightImpact()
                        self.purchasePro()
                    }
                
                SecondaryActionButton(title: "Restore purchase", color: Color("secondary"))
                    .onTapGesture {
                        HapticsGateway.shared.triggerLightImpact()
                        self.restorePro()
                    }
            } else {
                ActivityIndicator(isAnimating: $isLoading)
            }
        }.padding(.horizontal, 40)
        .padding(.bottom, 16)
        .navigationBarItems(leading: Button(action: {
            self.showPurchasePro = false
        }, label: {
            Text("Cancel")
        }))
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text("Error"), message: Text(errorAlertText), dismissButton: .default(Text("OK")))
        }
    }
    
    private func purchasePro() {
        self.isLoading = true
        
        SwiftyStoreKit.purchaseProduct("com.evh98.neon.pro", quantity: 1, atomically: true) { result in
            self.isLoading = false
            switch result {
            case .success: self.purchaseSuccess()
            case .error: self.purchaseError("Unfortunately your request for Hour Blocks Pro could not be processed")
            }
        }
    }
    
    private func restorePro() {
        self.isLoading = true
        
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            self.isLoading = false
            if results.restoreFailedPurchases.count > 0 {
                self.purchaseError("Unfortunately the restore request for Hour Blocks Pro could not be processed")
            } else if results.restoredPurchases.count > 0 {
                self.purchaseSuccess()
            } else {
                self.purchaseError("Unfortunately your request for Hour Blocks Pro could not be processed")
            }
        }
    }
    
    private func purchaseSuccess() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        DataGateway.shared.enablePro()
        showPurchasePro = false
    }
    
    private func purchaseError(_ errorMessage: String) {
        errorAlertText = errorMessage
        UINotificationFeedbackGenerator().notificationOccurred(.error)
        showErrorAlert = true
    }
}
