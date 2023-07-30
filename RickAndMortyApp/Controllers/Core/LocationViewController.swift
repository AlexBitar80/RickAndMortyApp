//
//  LocartionViewController.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 07/01/23.
//

import UIKit

final class LocationViewController: UIViewController {

    // MARK: - Properties
    
    private let primaryView = LocationView()
    
    private let viewModel = LocationViewViewModel()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        primaryView.delgate = self
        title = "Locations"
        view.backgroundColor = .systemBackground
        configureUI()
        addSearchButton()
        addConstraints()
        viewModel.delegate = self
        viewModel.fetchLocations()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.addSubview(primaryView)
    }
    
    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                                            target: self,
                                                            action: #selector(didTapSearch))
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            primaryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            primaryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            primaryView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            primaryView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    @objc private func didTapSearch() {
        
    }
}

// MARK: - LocationViewModel Delegate

extension LocationViewController: LocationViewViewModelDelegate {
    
    func didFetchInitialLocations() {
        primaryView.configure(with: viewModel)
    }
}

// MARK: - LocationViewDelegate

extension LocationViewController: LocationViewDelegate {
    func rmLocationView(_ locationView: LocationView,
                        didSelect location: Location) {
        let viewController = LocationDetailViewController(location: location)
        viewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(viewController, animated: true)
    }
}
