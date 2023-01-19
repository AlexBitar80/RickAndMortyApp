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
    
    public func execute(_ request: AppRequest, completion: @escaping () -> Void) {
        
    }
}
