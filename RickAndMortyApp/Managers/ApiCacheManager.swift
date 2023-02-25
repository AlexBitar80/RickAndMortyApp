//
//  ApiCacheManager.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 24/02/23.
//

import Foundation

final class ApiCacheManager {
    
    // MARK: - Properties
    
    private var cacheDictionary: [AppEndpoint: NSCache<NSString, NSData>] = [:]
    
    private var cache = NSCache<NSString, NSData>()
    
    // MARK: - Init
    
    init() {
        setUpCache()
    }
    
    // MARK: - Public
    
    public func cachedResponse(for endpoit: AppEndpoint, url: URL?) -> Data? {
        guard let targetCache = cacheDictionary[endpoit], let url else { return nil }
        
        let key = url.absoluteString as NSString
        return targetCache.object(forKey: key) as? Data
    }
    
    public func setCache(for endpoit: AppEndpoint, url: URL?, data: Data) {
        guard let targetCache = cacheDictionary[endpoit], let url else { return }
        
        let key = url.absoluteString as NSString
        targetCache.setObject(data as NSData, forKey: key)
    }
    
    // MARK: - Helpers
    
    private func setUpCache() {
        AppEndpoint.allCases.forEach({ endpoint in
            cacheDictionary[endpoint] = NSCache<NSString, NSData>()
        })
    }
}
