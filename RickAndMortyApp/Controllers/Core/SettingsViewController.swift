//
//  SettingsViewController.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 07/01/23.
//

import StoreKit
import UIKit
import SafariServices
import SwiftUI

final class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    
    private var settingsSwiftUIController: UIHostingController<SettingsView>?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        title = "Settings"
        view.backgroundColor = .systemBackground
        
        let settingsSwiftUIController = UIHostingController(
            rootView: SettingsView(
                viewModel: SettingsViewViewModel(
                    cellViewModels: SettingsOption.allCases.compactMap({
                        return SettingsCellViewModel(type: $0) { [weak self] option in
                            self?.tapHandler(option: option)
                        }
                    })
                )
            )
        )
        
        addChild(settingsSwiftUIController)
        settingsSwiftUIController.didMove(toParent: self)
        view.addSubview(settingsSwiftUIController.view)
        settingsSwiftUIController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            settingsSwiftUIController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingsSwiftUIController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            settingsSwiftUIController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            settingsSwiftUIController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        self.settingsSwiftUIController = settingsSwiftUIController
    }
    
    private func tapHandler(option: SettingsOption) {
        guard Thread.current.isMainThread else { return }
        
        if let url = option.targetUrl {
            let controller = SFSafariViewController(url: url)
            present(controller, animated: true)
        } else if option == .rateApp {
            if let windowScene = view.window?.windowScene {
                SKStoreReviewController.requestReview(in: windowScene)
            }
        }
    }
}
