//
//  CharacterInfoCollectionViewCellViewModel.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 10/02/23.
//

import Foundation
import UIKit


final class CharacterInfoCollectionViewCellViewModel {
    
    // MARK: - Properties
    
    private let type: `Type`
    
    private let value: String
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSZ"
        formatter.timeZone = .current
        return formatter
    }()
    
    static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.timeZone = .current
        return formatter
    }()
    
    public var title: String {
        type.displayTitle
    }
    
    public var displayValue: String {
        if value.isEmpty { return "None" }
        
        if let date = Self.dateFormatter.date(from: value), type == .created {
            return Self.shortDateFormatter.string(from: date)
        }
        
        return value
    }
    
    public var iconImage: UIImage? {
        return type.iconImage
    }
    
    public var tintColor: UIColor {
        return type.tintColor
    }
    
    enum `Type`: String {
        case status
        case gender
        case type
        case species
        case origin
        case location
        case created
        case episodeCount
        
        var tintColor: UIColor {
            switch self {
            case .status:
                return .systemOrange
            case .gender:
                return .systemGreen
            case .type:
                return .systemYellow
            case .species:
                return .systemBlue
            case .origin:
                return .systemRed
            case .location:
                return .systemPurple
            case .created:
                return .systemMint
            case .episodeCount:
                return .systemPink
            }
        }
        
        var iconImage: UIImage? {
            switch self {
            case .status:
                return UIImage(systemName: "doc")
            case .gender:
                return UIImage(systemName: "person.fill.questionmark.rtl")
            case .type:
                return UIImage(systemName: "bell")
            case .species:
                return UIImage(systemName: "person.fill.viewfinder")
            case .origin:
                return UIImage(systemName: "network")
            case .location:
                return UIImage(systemName: "location.square")
            case .created:
                return UIImage(systemName: "calendar")
            case .episodeCount:
                return UIImage(systemName: "play.tv")
            }
        }
        
        var displayTitle: String {
            switch self {
            case .status,
                 .gender,
                 .type,
                 .species,
                 .origin,
                 .location,
                 .created:
                return rawValue.uppercased()
            case .episodeCount:
                return "EPISODE COUNT"
            }
        }
    }
    
    // MARK: - Init
    
    init(type: `Type`, value: String) {
        self.value = value
        self.type = type
    }
}
