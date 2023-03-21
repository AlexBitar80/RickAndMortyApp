//
//  SettingsCellViewModel.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 20/03/23.
//

import UIKit

struct SettingsCellViewModel: Identifiable, Hashable {
   
    // MARK: - Properties
    
    var id = UUID()
    
    private let type: SettingsOption
    
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
    
    init(type: SettingsOption) {
        self.type = type
    }
}
