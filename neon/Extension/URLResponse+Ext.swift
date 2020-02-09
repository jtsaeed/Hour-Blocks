//
//  URLResponse+Ext.swift
//  neon
//
//  Created by James Saeed on 04/02/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import Foundation

extension URLResponse {
    
    var apiResponse: APIResponse {
        guard let statusCode = (self as? HTTPURLResponse)?.statusCode else { return .invalidResponse }
        
        if statusCode == 200 || statusCode == 201 {
            return .success
        } else if statusCode == 401 {
            return .invalidCredentials
        } else if statusCode == 404 {
            return .notFound
        } else if statusCode == 500 {
            return .internalServerError
        }
        
        return .invalidResponse
    }
}

enum APIResponse: String {
    
    case success = "The server request was successful!"
    case notFound = "404: Not Found"
    case internalServerError = "500: A server-side error occurred"
    case uploadError = "Firebase was unable to upload the image"
    case invalidResponse = "The server returned an invalid response"
    case invalidURL = "The URL provided was invalid"
    case invalidData = "The data provided to/received from the server was invalid"
    case invalidCredentials = "The credentials you provided are invalid"
}
