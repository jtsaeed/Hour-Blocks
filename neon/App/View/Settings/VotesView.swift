//
//  VotesView.swift
//  neon
//
//  Created by James Saeed on 08/02/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct VotesView: View {
    
    @ObservedObject var viewModel = FeedbackViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.features) { feature in
                NavigationLink(destination: VotesDetailView(viewModel: self.viewModel, feature: feature)) {
                    Text(feature.description)
                }
            }.onAppear {
                self.viewModel.getFeatures(completion: { response in })
            }
            .navigationBarTitle("Votes")
        }
    }
}

struct VotesDetailView: View {
    
    @ObservedObject var viewModel: FeedbackViewModel
    
    let feature: Feature
    
    var body: some View {
        VStack {
            Text("\(viewModel.voteCount) votes")
            Text("\(viewModel.proVoteCount) of them from Pro users")
        }.onAppear {
            self.viewModel.getVotes(for: self.feature, completion: { response in })
        }
        .navigationBarTitle(Text(feature.description), displayMode: .inline)
    }
}
