//
//  SearchResultViewViewModel.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 28/09/23.
//

import Foundation

enum SearchResultViewViewModel {
    case characters([CharacterCollectionViewCelltViewViewModel])
    case locations([LocationTableViewCellViewModel])
    case episodes([CharacterEpisodesCollectionViewCellViewModel])
}
