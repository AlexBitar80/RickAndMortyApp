//
//  SettingsCellViewModel.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 20/03/23.
//

import UIKit

struct SettingsCellViewModel: Identifiable {
   
    // MARK: - Properties
    
    var id = UUID()
    
    public let type: SettingsOption
    public let onTapHandler: (SettingsOption) -> Void
    
    public var image: UIImage? {
        return type.iconImage
    }
    
    public var title: String {
        return type.displayTitle
    }
    
    public var iconContainerColor: UIColor {
        return type.iconContainerColor
    }
    
    // MARK: - Init
    
    init(type: SettingsOption, onTapHandler: @escaping (SettingsOption) -> Void) {
        self.type = type
        self.onTapHandler = onTapHandler
    }
}
