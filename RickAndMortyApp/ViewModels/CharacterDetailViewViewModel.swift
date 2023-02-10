//
//  CharacterDetailViewViewModel.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 25/01/23.
//

import Foundation

final class CharacterDetailViewViewModel {
    
    // MARK: - Properties
    
    private let character: RMCharacter
    
    enum SectionType: CaseIterable {
        case photo
        case information
        case episode
    }
    
    public let sections = SectionType.allCases
    
    // MARK: - Init
    
    init(character: RMCharacter) {
        self.character = character
    }
    
    // MARK: - Helpers
    
    private var requestUrl: URL? {
        guard let url = character.url else { return nil }
        return URL(string: url)
    }
    
    public var title: String {
        guard let name = character.name else { return "" }
        return name.uppercased()
    }
}
