//
//  CharacterPhotoCollectionViewCellViewModel.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 10/02/23.
//

import Foundation

final class CharacterPhotoCollectionViewCellViewModel {
    
    // MARK: - Properties
    
    private let imageUrl: URL?
    
    // MARK: - Init
    
    init(imageUrl: URL?) {
        self.imageUrl = imageUrl
    }
    
    // MARK: - Helpers
    
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        
        guard let imageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        AppImageLoader.shared.downloadImage(imageUrl, completion: completion)
    }
}
