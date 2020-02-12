//
//  FeedbackViewModel.swift
//  neon
//
//  Created by James Saeed on 04/02/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import Foundation

class FeedbackViewModel: ObservableObject {
    
    @Published var hasVoted = false
    @Published var features = [Feature]()
    
    @Published var voteCount = 0
    @Published var proVoteCount = 0
    
    func getFeatures(completion: @escaping (APIResponse) -> ()) {
        APIGateway.shared.getFeatures { features, response in
            if let features = features {
                DispatchQueue.main.async { self.features = features }
            }
            
            completion(response)
        }
    }
    
    func getVotes(for feature: Feature, completion: @escaping (APIResponse) -> ()) {
        APIGateway.shared.getVotes(for: feature) { votes, response in
            if let votes = votes {
                self.voteCount = votes.count
                self.proVoteCount = votes.filter({ $0.proUser == "true" }).count
            }
            
            completion(response)
        }
    }
    
    func checkVote() {
        APIGateway.shared.checkVote { response in
            if response == .success {
                self.hasVoted = true
            }
        }
    }
    
    func vote(for feature: Feature, completion: @escaping (APIResponse) -> ()) {
        APIGateway.shared.vote(for: feature) { response in
            completion(response)
        }
    }
}
