//
//  ImageLoader.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 29/01/23.
//

import Foundation

final class AppImageLoader {
    
    // MARK: - Properties
    
    static let shared = AppImageLoader()
    
    // MARK: - Init
    
    private var imageDataCache = NSCache<NSString, NSData>()
    
    private init() {
        
    }
    
    public func downloadImage(_ url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let key = url.absoluteString as NSString
        if let data = imageDataCache.object(forKey: key) {
            completion(.success(data as Data)) // NSData == Data || NSString == String
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
          
            let value = data as NSData
            self?.imageDataCache.setObject(value, forKey: key)
            
            completion(.success(data))
        }
        task.resume()
    }
}
