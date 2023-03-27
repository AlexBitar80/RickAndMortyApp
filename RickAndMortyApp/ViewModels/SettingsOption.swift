//
//  SettingsOption.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 20/03/23.
//

import UIKit

enum SettingsOption: CaseIterable {
    case rateApp
    case contactUs
    case terms
    case privacy
    case apiReference
    case viewSeries
    case viewCode
    
    var displayTitle: String {
        switch self {
        case .rateApp:
            return "Avaliar o App"
        case .contactUs:
            return "Nosso contanto"
        case .terms:
            return "Termos de uso"
        case .privacy:
            return "Politica de privacidade"
        case .apiReference:
            return "Referencia de API"
        case .viewSeries:
            return "Visualizar série"
        case .viewCode:
            return "Código fonte"
        }
    }
    
    var iconContainerColor: UIColor {
        switch self {
        case .rateApp:
            return .systemBlue
        case .contactUs:
            return .systemGreen
        case .terms:
            return .systemYellow
        case .privacy:
            return .systemPurple
        case .apiReference:
            return .systemRed
        case .viewSeries:
            return .systemOrange
        case .viewCode:
            return .systemCyan
        }
    }
    
    var iconImage: UIImage? {
        switch self {
        case .rateApp:
            return UIImage(systemName: "star.fill")
        case .contactUs:
            return UIImage(systemName: "envelope.fill")
        case .terms:
            return UIImage(systemName: "doc.text")
        case .privacy:
            return UIImage(systemName: "lock.fill")
        case .apiReference:
            return UIImage(systemName: "book.fill")
        case .viewSeries:
            return UIImage(systemName: "tv.fill")
        case .viewCode:
            return UIImage(systemName: "chevron.left.slash.chevron.right")
        }
    }
}
