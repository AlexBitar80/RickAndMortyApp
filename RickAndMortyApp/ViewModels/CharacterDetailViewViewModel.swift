//
//  CharacterDetailViewViewModel.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 25/01/23.
//

import Foundation

final class CharacterDetailViewViewModel {
    private let character: RMCharacter
    
    init(character: RMCharacter) {
        self.character = character
    }
    
    private var requestUrl: URL? {
        guard let url = character.url else { return nil }
        return URL(string: url)
    }
    
    public var title: String {
        guard let name = character.name else { return "" }
        return name.uppercased()
    }
    
    // MARK: - Helpers
    
    
}
