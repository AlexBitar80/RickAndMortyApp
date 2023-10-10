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
        
        var queryArgumentes: String {
            switch self {
            case .status: return "status"
            case .gender: return "gender"
            case .locationType: return "type"
            }
        }
        
        var choises: [String] {
            switch self {
            case .gender:
                return ["male", "female", "genderless", "unknown"]
            case .locationType:
                return ["planet", "space station", "microverse", "tv", "resort", "fantasy town", "dream", "dimension", "unknown", "post-apocalyptic earth", "nuptia 4", "earth", "purge planet", "venzenulon 7", "bepis 9", "grumbo", "pluto", "earth (c-137]"]
            case .status:
                return ["alive", "dead", "unknown"]
            }
        }
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
