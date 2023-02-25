//
//  Service.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 17/01/23.
//

import Foundation

enum ServiceError: Error {
    case failedToCreateRequest
    case failedToGetData
}

final class AppService {
    static let shared = AppService()
    
    private let cacheManager = ApiCacheManager()
    
    private init() {}
    
    public func execute<T: Codable>(_ request: AppRequest,
                                    expecting type: T.Type,
                                    completion: @escaping (Result<T, ServiceError>) -> Void) {
        
        if let cachedData = cacheManager.cachedResponse(for: request.endpoint,
                                                        url: request.url) {
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(type.self, from: cachedData)
                completion(.success(result))
            } catch {
                completion(.failure(error as! ServiceError))
            }
            
            return
        }
        
        guard let urlRequest = self.request(from: request) else {
            completion(.failure(.failedToCreateRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(.failedToGetData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(type.self, from: data)
                self?.cacheManager.setCache(for: request.endpoint, url: request.url, data: data)
                completion(.success(result))
            } catch {
                completion(.failure(.failedToGetData))
            }
        }
        task.resume()
    }
    
    private func request(from appRequest: AppRequest) -> URLRequest? {
        guard let url = appRequest.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = appRequest.httpMethod
        
        return request
    }
}
