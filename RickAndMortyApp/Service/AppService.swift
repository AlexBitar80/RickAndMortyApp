//
//  Service.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 17/01/23.
//

import Foundation

final class AppService {
    static let shared = AppService()
    
    private init() {}
    
    public func execute<T: Codable>(_ request: AppRequest,
                                    expecting type: T.Type,
                                    completion: @escaping (Result<T, Error>) -> Void) {
        
        
    }
    
    
}
