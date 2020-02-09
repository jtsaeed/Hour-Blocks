//
//  Vote.swift
//  neon
//
//  Created by James Saeed on 04/02/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import Foundation
import UIKit

struct Feature: Identifiable, Decodable {
    
    let id: String
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case description
    }
}

struct Vote: Identifiable, Codable {
    
    let id: String
    let featureId: String?
    let deviceId: String
    let appVersion: String
    let proUser: String?
    
    init() {
        self.id = UUID().uuidString
        self.featureId = nil
        self.deviceId = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
        self.appVersion = "\(DataGateway.shared.currentVersion)"
        self.proUser = nil
    }
    
    init(for feature: Feature) {
        self.id = UUID().uuidString
        self.featureId = feature.id
        self.deviceId = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
        self.appVersion = "\(DataGateway.shared.currentVersion)"
        self.proUser = DataGateway.shared.isPro().description
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case featureId, deviceId, appVersion, proUser
    }
}
