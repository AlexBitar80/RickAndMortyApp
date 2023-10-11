//
//  LocationDetailViewController.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 30/07/23.
//

import UIKit

final class LocationDetailViewController: UIViewController {

    // MARK: - Properties
    
    private let viewModel: LocationDetailViewViewModel?
    
    private let detailView = RickAndMortyApp.LocationDetailView()
    
    // MARK: - Init
    
    init(location: Location) {
        let url = URL(string: location.url ?? "")
        self.viewModel = LocationDetailViewViewModel(endpointUrl: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupDelegate()
        setupConstraints()
        
        viewModel?.fetchLocationData()
    }
    
    // MARK: - Helpers
    
    private func setupDelegate() {
        viewModel?.delegate = self
        detailView.delegate = self
    }
    
    private func configureUI() {
        title = "Location"
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self,
                                                            action: #selector(didTapShare))
        
        view.addSubview(detailView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            detailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    @objc private func didTapShare() {
        
    }
}

// MARK: - EpisodeDetailViewViewModelDelegate

extension LocationDetailViewController: LocationDetailViewViewModelDelegate {
    func didFetchLocationDetails() {
        guard let viewModel else { return }
        
        detailView.configure(with: viewModel)
    }
}


// MARK: - EpisodeDetailViewDelegate

extension LocationDetailViewController: LocationDetailViewDelegate {
    func LocationDetailView(_ detailView: LocationDetailView,
                           didSelect character: RMCharacter) {
        
        let controller = CharacterDetailViewController(viewModel: .init(character: character))
        controller.navigationItem.title = character.name
        controller.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(controller, animated: true)
    }
}
