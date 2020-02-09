//
//  APIGateway.swift
//  neon
//
//  Created by James Saeed on 04/02/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import Foundation

class APIGateway {
    
    static let shared = APIGateway()
    
    let baseURL = "https://jtsaeed-neon.appspot.com"
    
    private func request(_ type: RequestType, endpoint: String, body: Data?, completion: @escaping (Data?, APIResponse) -> ()) {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            completion(nil, .invalidURL)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = type.rawValue
        
        if type == .post || type == .patch {
            request.httpBody = body
            
            var headers = request.allHTTPHeaderFields ?? [:]
            headers["Content-Type"] = "application/json"
            request.allHTTPHeaderFields = headers
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let response = response else {
                completion(data, .invalidResponse)
                return
            }
            
            completion(data, response.apiResponse)
        }.resume()
    }
}

extension APIGateway {
    
    func checkVote(completion: @escaping (APIResponse) -> ()) {
        let vote = Vote()
        guard let data = try? JSONEncoder().encode(vote) else {
            completion(.invalidData)
            return
        }
        
        request(.post, endpoint: "/votes/exists", body: data) { data, response in
            completion(response)
        }
    }
    
    func vote(for feature: Feature, completion: @escaping (APIResponse) -> ()) {
        let vote = Vote(for: feature)
        guard let data = try? JSONEncoder().encode(vote) else {
            completion(.invalidData)
            return
        }
        
        request(.post, endpoint: "/votes", body: data) { _, response in
            completion(response)
        }
    }
    
    func getVotes(for feature: Feature, completion: @escaping ([Vote]?, APIResponse) -> ()) {
        request(.get, endpoint: "/votes/\(feature.id)", body: nil) { data, response in
            guard let data = data else {
                completion(nil, response)
                return
            }
            
            guard let votes = try? JSONDecoder().decode([Vote].self, from: data) else {
                completion(nil, .invalidData)
                return
            }
            
            completion(votes, response)
        }
    }
    
    func getFeatures(completion: @escaping ([Feature]?, APIResponse) -> ()) {
        request(.get, endpoint: "/features", body: nil) { data, response in
            guard let data = data else {
                completion(nil, response)
                return
            }
            
            guard let features = try? JSONDecoder().decode([Feature].self, from: data) else {
                completion(nil, .invalidData)
                return
            }
            
            completion(features, response)
        }
    }
}

enum RequestType: String {
    
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
}
