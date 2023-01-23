//
//  AppRequest.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 17/01/23.
//

import Foundation

final class AppRequest {
    
    private struct Constants {
        static let baseUrl = "https://rickandmortyapi.com/api"
    }
    
    private let endpoint: AppEndpoint
    
    private let pathComponents: [String]
    
    private let queryParameters: [URLQueryItem]
    
    private var urlString: String {
        var string = Constants.baseUrl
        string += "/"
        string += endpoint.rawValue
        
        if !pathComponents.isEmpty {
            pathComponents.forEach({
                string += "/\($0)"
            })
        }
        
        if !queryParameters.isEmpty {
            string += "?"
            
            let argumentsString = queryParameters.compactMap({
                guard let value = $0.value else { return nil }
                return "\($0.name)=\(value)"
            }).joined(separator: "&")
            
            string += argumentsString
        }
        
        return string
    }
    
    // MARK: - Public
    
    public let httpMethod = "GET"
    
    public var url: URL? {
        return URL(string: urlString)
    }

    public init(endpoint: AppEndpoint, pathComponents: [String] = [], queryParameters: [URLQueryItem] = []) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }
}

extension AppRequest {
    static let listCharacterRequests = AppRequest(endpoint: .character)
}
