//
//  NewBlockView.swift
//  neon3
//
//  Created by James Saeed on 23/06/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import SwiftUI

// MARK: - New Block View

struct NewBlockView: View {
    
    @EnvironmentObject var suggestions: SuggestionsStore
    
    @Binding var isPresented: Bool
    @Binding var title: String
    
    let formattedTime: String
    
    var didAddBlock: (String) -> ()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                NewTextField(title: $title, didReturn: { title in
                    if self.title.isEmpty {
                        UINotificationFeedbackGenerator().notificationOccurred(.error)
                    } else {
                        self.addBlock(with: self.title, isSuggestion: false)
                    }
                })
                Text("Suggestions")
                    .font(.system(size: 28, weight: .semibold, design: .default))
                    .padding(.leading, 24)
                List {
                    if suggestions.list.count > 0 {
                        ForEach(suggestions.list, id: \.self) { suggestion in
                            SuggestionCard(suggestion: suggestion, didAddBlock: { title in
                                self.addBlock(with: title, isSuggestion: true)
                            })
                        }
                    } else {
                        NoSuggestionsCard()
                    }
                }
                Spacer()
            }
            .navigationBarTitle(formattedTime.lowercased())
            .navigationBarItems(leading: Button(action: {
                self.isPresented = false
            }, label: {
                Text("Cancel")
            }), trailing: Button(action: {
                if self.title.isEmpty {
                    UINotificationFeedbackGenerator().notificationOccurred(.error)
                } else {
                    self.addBlock(with: self.title, isSuggestion: false)
                }
            }, label: {
                Text("Add")
            }))
        }.accentColor(Color("primary"))
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func addBlock(with title: String, isSuggestion: Bool) {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        isPresented = false
        let domain = DomainsGateway.shared.determineDomain(for: title)
        
        AnalyticsGateway.shared.logHourBlock(for: domain?.key ?? "default",
                                             at: formattedTime,
                                             isSuggestion: isSuggestion)
        
        didAddBlock(title)
    }
}

struct SuggestionCard: View {
    
    let suggestion: Suggestion
    
    var didAddBlock: (String) -> ()
    
    var body: some View {
        ZStack {
            Card()
            HStack {
                CardLabels(title: suggestion.title,
                           subtitle: suggestion.reason.uppercased())
                Spacer()
                Image("add_button")
                .onTapGesture {
                    self.didAddBlock(self.suggestion.title)
                }
            }.padding(EdgeInsets(top: 18, leading: 22, bottom: 18, trailing: 24))
        }.padding(EdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8))
    }
}

struct NoSuggestionsCard: View {
    
    var body: some View {
        ZStack {
            Card()
            HStack {
                CardLabels(title: "None",
                           subtitle: "Currently",
                           titleColor: Color("subtitle"),
                           alignment: .center)
            }.padding(EdgeInsets(top: 18, leading: 22, bottom: 18, trailing: 24))
        }.padding(EdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8))
    }
}

// MARK: New To Do Item View

struct NewToDoItemView: View {
    
    @Binding var isPresented: Bool
    
    @Binding var title: String
    @Binding var priority: ToDoPriority
    
    var didAddToDoItem: (String, ToDoPriority) -> ()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                NewTextField(title: $title, didReturn: { title in })
                Picker("Set a priority", selection: $priority) {
                    Text(ToDoPriority.high.rawValue).tag(ToDoPriority.high)
                    Text(ToDoPriority.medium.rawValue).tag(ToDoPriority.medium)
                    Text(ToDoPriority.low.rawValue).tag(ToDoPriority.low)
                    Text(ToDoPriority.none.rawValue).tag(ToDoPriority.none)
                }.labelsHidden()
                Spacer()
            }
            .navigationBarTitle("What's on your list?")
            .navigationBarItems(leading: Button(action: {
                self.isPresented = false
            }, label: {
                Text("Cancel")
            }), trailing: Button(action: {
                if self.title.isEmpty {
                    UINotificationFeedbackGenerator().notificationOccurred(.error)
                } else {
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                    self.isPresented = false
                    AnalyticsGateway.shared.logToDo()
                    self.didAddToDoItem(self.title, self.priority)
                }
            }, label: {
                Text("Add")
            }))
        }.accentColor(Color("primary"))
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct NewTextField: View {
    
    @Binding var title: String
    
    var didReturn: (String) -> ()

    var body: some View {
        ZStack() {
            Rectangle()
                .frame(height: 44)
                .foregroundColor(Color("secondary"))
                .cornerRadius(8)
            TextField("Enter the title here...", text: $title) {
                self.didReturn(self.title)
            }
                .autocapitalization(.none)
                .font(.system(size: 17, weight: .medium, design: .default))
                .foregroundColor(Color("title"))
                .padding(.horizontal, 16)
        }.padding(24)
    }
}
