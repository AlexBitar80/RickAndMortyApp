//
//  CharacterDetailViewViewModel.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 25/01/23.
//

import Foundation
import UIKit

final class CharacterDetailViewViewModel {
    
    // MARK: - Properties
    
    private let character: RMCharacter
    
    public var episodes: [String] {
        character.episode ?? [""]
    }
    
    enum SectionType {
        case photo(viewModel: CharacterPhotoCollectionViewCellViewModel)
        
        case information(viewModels: [CharacterInfoCollectionViewCellViewModel])
        
        case episodes(viewModels: [CharacterEpisodesCollectionViewCellViewModel])
    }
    
    public var sections: [SectionType] = []
    
    // MARK: - Init
    
    init(character: RMCharacter) {
        self.character = character
        setupSections()
    }
    
    // MARK: - Helpers
    
    private func setupSections() {
        guard let image = character.image,
              let episodes = character.episode,
              let statusText = character.status?.text,
              let genderText = character.gender?.rawValue,
              let typeText = character.type,
              let speciesText = character.species,
              let originText = character.origin?.name,
              let locationText = character.location?.name,
              let createdText = character.created
        else { return }
        
        
        sections = [
            .photo(viewModel: .init(imageUrl: URL(string: image))),
            .information(viewModels: [
                .init(type: .status, value: statusText),
                .init(type: .gender, value: genderText),
                .init(type: .type, value: typeText),
                .init(type: .species, value: speciesText),
                .init(type: .origin, value: originText),
                .init(type: .location, value: locationText),
                .init(type: .created, value: createdText),
                .init(type: .episodeCount, value: "\(character.episode?.count ?? 0)"),
            ]),
            .episodes(viewModels: episodes.compactMap ({
                return CharacterEpisodesCollectionViewCellViewModel(episodeDataUrl: URL(string: $0))
            }))
        ]
    }
    
    private var requestUrl: URL? {
        guard let url = character.url else { return nil }
        return URL(string: url)
    }
    
    public var title: String {
        guard let name = character.name else { return "" }
        return name.uppercased()
    }
    
    // MARK: - Layours
    
    public func createPhotoSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                             heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                     leading: 0,
                                                     bottom: 10,
                                                     trailing: 0)
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                        heightDimension: .fractionalHeight(0.5)),
                                                     subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    public func createInfoSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                                             heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 2,
                                                     leading: 2,
                                                     bottom: 2,
                                                     trailing: 2)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                        heightDimension: .absolute(150)),
                                                     subitems: [item, item])
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    public func createEpisodeSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                             heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 10,
                                                     leading: 5,
                                                     bottom: 10,
                                                     trailing: 8)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8),
                                                                                        heightDimension: .absolute(150)),
                                                     subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    
    
}
