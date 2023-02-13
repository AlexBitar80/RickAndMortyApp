//
//  CharacterEpisodesCollectionViewCellViewModel.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 10/02/23.
//

import Foundation


final class CharacterEpisodesCollectionViewCellViewModel {
    
    // MARK: - Properties
    
    private let episodeDataUrl: URL?
    
    // MARK: - Init
    
    init(episodeDataUrl: URL?) {
        self.episodeDataUrl = episodeDataUrl
    }
}
