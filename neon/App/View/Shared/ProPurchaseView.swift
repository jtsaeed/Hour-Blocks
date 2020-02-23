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
        VStack(spacing: 20) {
            WhatsNewHeader(title: "Hour Blocks Pro")
                .padding(.vertical, 32)
            
            VStack(alignment: .leading, spacing: 16) {
                WhatsNewItem(title: "Sub Blocks 💪",
                             content: NSLocalizedString("Add as many Sub Blocks as you want to an Hour Block for maximum productivity", comment: ""))
                WhatsNewItem(title: NSLocalizedString("Alternate App Icons 🎨", comment: ""),
                             content: NSLocalizedString("Choose from 3 different app icons to display on your home screen", comment: ""))
            }
            
            Spacer()
            
            if !isLoading {
                    ActionButton(title: NSLocalizedString("Let's go Pro!", comment: ""),
                                 color: Color("secondary"))
                        .onTapGesture(perform: purchasePro)
                    SecondaryActionButton(title: NSLocalizedString("Restore purchase", comment: ""),
                                          color: Color("secondary"))
                        .onTapGesture(perform: restorePro)
                    SecondaryActionButton(title: NSLocalizedString("No thanks!", comment: ""),
                                          color: Color("secondary"))
                        .onTapGesture(perform: dismiss)
            } else {
                ActivityIndicator(isAnimating: $isLoading)
            }
        }.padding(.horizontal, 40)
        .padding(.bottom, 16)
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text("Error"), message: Text(errorAlertText), dismissButton: .default(Text("OK")))
        }
        .accentColor(Color("secondary"))
    }
    
    func dismiss() {
        showPurchasePro = false
    }
    
    func purchasePro() {
        HapticsGateway.shared.triggerLightImpact()
        
        self.isLoading = true
        
        SwiftyStoreKit.purchaseProduct("com.evh98.neon.pro", quantity: 1, atomically: true) { result in
            self.isLoading = false
            switch result {
            case .success: self.purchaseSuccess()
            case .error: self.purchaseError("Unfortunately your request for Hour Blocks Pro could not be processed")
            }
        }
    }
    
    func restorePro() {
        HapticsGateway.shared.triggerLightImpact()
        
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
