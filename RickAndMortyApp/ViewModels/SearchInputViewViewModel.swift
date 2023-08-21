//
//  SearchInputViewViewModel.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 13/08/23.
//

import Foundation

final class SearchInputViewViewModel {
    
    // MARK: - Properties
    
    private let type: SearchViewController.Config.`Type`
    
    enum DynamicOption: String {
        case status = "Status"
        case gender = "Gender"
        case locationType = "Location Type"
    }
    
    // MARK: - Init
    
    init(type: SearchViewController.Config.`Type`) {
        self.type = type
    }
    
    // MARK: - Helpers
    
    var hasDynamicOptions: Bool {
        switch type {
        case .character:
            return true
        case .location:
            return true
        case .episode:
            return false
        }
    }
    
    var options: [DynamicOption] {
        switch type {
        case .character:
            return [.status, .gender]
        case .location:
            return [.locationType]
        case .episode:
            return []
        }
    }
    
    var searchPlaceholderText: String {
        switch type {
        case .character:
            return "Character Name"
        case .location:
            return "Location Name"
        case .episode:
            return "Episode Name"
        }
    }
}
