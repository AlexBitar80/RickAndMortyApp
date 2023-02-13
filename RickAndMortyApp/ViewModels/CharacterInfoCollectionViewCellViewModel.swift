//
//  CharacterInfoCollectionViewCellViewModel.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 10/02/23.
//

import Foundation


final class CharacterInfoCollectionViewCellViewModel {
    
    // MARK: - Properties
    
    public let value: String
    public let title: String
    
    // MARK: - Init
    
    init(value: String, title: String) {
        self.value = value
        self.title = title
    }
}
