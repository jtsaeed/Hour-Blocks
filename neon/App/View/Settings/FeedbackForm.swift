//
//  FeedbackForm.swift
//  neon
//
//  Created by James Saeed on 29/02/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct FeedbackForm: View {
    
    @Binding var isPresented: Bool
    
    @State var name = ""
    
    @State var selectedTopic = 0
    @State var topics = ["Feature Request", "Bug", "Translation", "Other"]
    
    @State var content = ""
    
    @State var showAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Info")) {
                    TextField("Name", text: $name)
                }
                
                Section(header: Text("Message")) {
                    Picker(selection: $selectedTopic, label: Text("Topic")) {
                        ForEach(0 ..< topics.count) { index in
                            Text(self.topics[index]).tag(index)
                        }
                    }
                    TextField("Content", text: $content)
                }
                
                Section(header: Text("Additional Info")) {
                    Text("Device - iPhone 11 Pro")
                    Text("iOS - 13.3.1")
                    Text("Hour Blocks - v\(DataGateway.shared.fullCurrentVersion)")
                }
            }.navigationBarTitle("Feedback")
            .navigationBarItems(leading: Button(action: dismiss, label: {
                Text("Cancel")
            }), trailing: Button(action: send, label: {
                Text("Send")
            }))
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"),
                      message: Text("Failed to generate Email, please make sure all fields are filled"),
                      dismissButton: .default(Text("OK")))
            }
        }.accentColor(Color("primary"))
    }
    
    func dismiss() {
        isPresented = false
    }
    
    func send() {
        guard !name.isEmpty else {
            showAlert = true
            return
        }
        
        guard !content.isEmpty else {
            showAlert = true
            return
        }
        
        guard let urlString = "mailto:support@jtsaeed.com?subject=\(topics[selectedTopic]) from \(name)&body=\(content)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            showAlert = true
            return
        }
        
        guard let url = URL(string: urlString) else {
            showAlert = true
            return
        }
        
        UIApplication.shared.open(url)
        
        dismiss()
    }
}
