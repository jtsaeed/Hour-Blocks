//
//  AddHourBlockView.swift
//  neon
//
//  Created by James Saeed on 13/02/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct AddHourBlockView: View {
    
    @Binding var isPresented: Bool
    
    @ObservedObject var viewModel: ScheduleViewModel
    
    let hour: Int
    let time: String
    let day: Date
    
    @State var title = ""
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                NeonTextField(title: $title, didReturn: addBlock)
                Text("Suggestions")
                    .font(.system(size: 28, weight: .semibold, design: .default))
                    .padding(.leading, 24)
                List {
                    if viewModel.currentSuggestions.count > 0 {
                        ForEach(viewModel.currentSuggestions, id: \.self) { suggestion in
                            SuggestionCard(suggestion: suggestion) { title in
                                self.title = title
                                self.addBlock()
                            }
                        }
                    } else {
                        NoSuggestionsCard()
                    }
                }
            }
            .navigationBarTitle(time)
            .navigationBarItems(leading: Button(action: dismiss, label: {
                Text("Cancel")
            }), trailing: Button(action: addBlock, label: {
                Text("Add")
            }))
        }.accentColor(Color("primary"))
        .onAppear(perform: loadSuggestions)
    }
    
    func loadSuggestions() {
        viewModel.loadSuggestions(for: hour, on: day)
    }
    
    func dismiss() {
        isPresented = false
    }
    
    func addBlock() {
        if self.title.isEmpty {
            HapticsGateway.shared.triggerErrorHaptic()
        } else {
            HapticsGateway.shared.triggerAddBlockHaptic()
            
            let hourBlock = HourBlock(day: viewModel.currentDate,
                                      hour: hour,
                                      title: title)
            viewModel.add(hourBlock: hourBlock)
            
            dismiss()
        }
    }
}

private struct SuggestionCard: View {
    
    let suggestion: Suggestion
    
    var didAddBlock: (String) -> ()
    
    var body: some View {
        Card {
            HStack {
                CardLabels(title: self.suggestion.domain.suggestionTitle,
                           subtitle: self.suggestion.reason.uppercased())
                Spacer()
                IconButton(iconName: "add_icon", action: self.add)
            }
        }
    }
    
    func add() {
        didAddBlock(suggestion.domain.suggestionTitle)
    }
}
