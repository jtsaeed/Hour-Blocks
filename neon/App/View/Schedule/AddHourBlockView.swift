//
//  AddHourBlockView.swift
//  neon
//
//  Created by James Saeed on 13/02/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI
import StoreKit

struct AddHourBlockView: View {
    
    @Binding var isPresented: Bool
    
    @EnvironmentObject var viewModel: ScheduleViewModel
    
    let hour: Int
    let time: String
    let day: Date
    let isSubBlock: Bool
    
    @State var title = ""
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                NeonTextField(title: $title,
                              color: Color("primaryLight"),
                              didReturn: addBlock)
                Text("Suggestions")
                    .font(.system(size: 28, weight: .semibold, design: .default))
                    .padding(.leading, 24)
                List {
                    if viewModel.currentSuggestions.count > 0 {
                        ForEach(viewModel.currentSuggestions) { suggestion in
                            SuggestionCard(suggestion: suggestion, isSubBlock: self.isSubBlock) { title in
                                AnalyticsGateway.shared.log(suggestion: suggestion)
                                self.title = title
                                self.addBlock()
                            }
                        }
                    } else {
                        NoSuggestionsCard()
                    }
                }.onAppear(perform: loadSuggestions)
            }
            .navigationBarTitle(time.lowercased())
            .navigationBarItems(leading: Button(action: dismiss, label: {
                Text("Cancel")
            }), trailing: Button(action: addBlock, label: {
                Text("Add")
            }))
        }.navigationViewStyle(StackNavigationViewStyle())
        .accentColor(Color("primary"))
        
    }
   
    func loadSuggestions() {
        viewModel.loadSuggestions(for: hour,
                                  on: day,
                                  parentDomain: DomainsGateway.shared.determineDomain(for: title))
    }
    
    func dismiss() {
        isPresented = false
    }
    
    func addBlock() {
        if self.title.isEmpty {
            HapticsGateway.shared.triggerErrorHaptic()
        } else {
            HapticsGateway.shared.triggerAddBlockHaptic()
            
            var hourBlock = HourBlock(day: viewModel.currentDate,
                                      hour: hour,
                                      title: title)
            hourBlock.isSubBlock = isSubBlock
            viewModel.add(hourBlock: hourBlock)
            
            dismiss()
            
            handleReviewRequest()
        }
    }
    
    func handleReviewRequest() {
        if DataGateway.shared.getTotalBlockCount() == 10 {
            SKStoreReviewController.requestReview()
        }
    }
}

private struct SuggestionCard: View {
    
    let suggestion: Suggestion
    let isSubBlock: Bool
    
    var didAddBlock: (String) -> ()
    
    var body: some View {
        Card {
            HStack {
                CardLabels(title: self.suggestion.title,
                           subtitle: self.suggestion.reason.uppercased())
                Spacer()
                IconButton(iconName: "add_icon",
                           action: self.add)
            }
        }
    }
    
    func add() {
        didAddBlock(suggestion.title)
    }
}
