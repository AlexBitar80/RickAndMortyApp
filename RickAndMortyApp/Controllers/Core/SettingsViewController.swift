//
//  SettingsViewController.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 07/01/23.
//

import UIKit
import SwiftUI

final class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel = SettingsViewViewModel(cellViewModels: SettingsOption.allCases.compactMap({
        return SettingsCellViewModel(type: $0)
    }))
    
    private var settingsSwiftUIViewController = UIHostingController(
        rootView: SettingsView(
            viewModel: SettingsViewViewModel(
                cellViewModels: SettingsOption.allCases.compactMap({
                    return SettingsCellViewModel(type: $0)
                })
            )
        )
    )
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupConstraints()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        title = "Settings"
        view.backgroundColor = .systemBackground
        addChild(settingsSwiftUIViewController)
        settingsSwiftUIViewController.didMove(toParent: self)
        view.addSubview(settingsSwiftUIViewController.view)
        settingsSwiftUIViewController.view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            settingsSwiftUIViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingsSwiftUIViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            settingsSwiftUIViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            settingsSwiftUIViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
