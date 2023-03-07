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
    
    let endpoint: AppEndpoint
    
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
    
    convenience init?(url: URL) {
        let string = url.absoluteString
        if !string.contains(Constants.baseUrl) {
            return nil
        }
        
        let trimed = string.replacingOccurrences(of: Constants.baseUrl+"/", with: "")
        
        if trimed.contains("/") {
            let components = trimed.components(separatedBy: "/")
            if !components.isEmpty {
                let endpointString = components[0] // Endpoint
                var pathComponents: [String] = []
                if components.count > 1 {
                    pathComponents = components
                    pathComponents.removeFirst()
                }
                
                if let appEndpoint = AppEndpoint(rawValue: endpointString) {
                    self.init(endpoint: appEndpoint, pathComponents: pathComponents)
                    return
                }
            }
        } else if trimed.contains("?") {
            let components = trimed.components(separatedBy: "?")
            if !components.isEmpty, components.count >= 2 {
                let endpointString = components[0]
                let queryItemsString = components[1]
                let queryItems: [URLQueryItem] = queryItemsString.components(separatedBy: "&").compactMap({
                    guard $0.contains("=") else {
                        return nil
                    }
                    let parts = $0.components(separatedBy: "=")
                    
                    return URLQueryItem(name: parts[0],
                                        value: parts[1])
                })
                if let appEndpoint = AppEndpoint(rawValue: endpointString) {
                    self.init(endpoint: appEndpoint, queryParameters: queryItems)
                    return
                }
            }
        }
        
        return nil
    }
}

extension AppRequest {
    static let listCharactersRequests = AppRequest(endpoint: .character)
    static let listEpisodesRequest = AppRequest(endpoint: .episode)
}
