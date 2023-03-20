//
//  EpisodeDetailViewController.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 14/02/23.
//

import UIKit

final class EpisodeDetailViewController: UIViewController {

    // MARK: Properties
    
    private let viewModel: EpisodeDetailViewViewModel?
    
    private let detailView = EpisodeDetailView()
    
    // MARK: - Init
    
    init(url: URL?) {
        self.viewModel = EpisodeDetailViewViewModel(endpointUrl: url)
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
        
        viewModel?.fetchEpisodeData()
    }
    
    // MARK: - Helpers
    
    private func setupDelegate() {
        viewModel?.delegate = self
        detailView.delegate = self
    }
    
    private func configureUI() {
        title = "Episode"
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

extension EpisodeDetailViewController: EpisodeDetailViewViewModelDelegate {
    func didFetchEpisodeDetails() {
        guard let viewModel else { return }
        
        detailView.configure(with: viewModel)
    }
}


// MARK: - EpisodeDetailViewDelegate

extension EpisodeDetailViewController: EpisodeDetailViewDelegate {
    func episodeDetailView(_ detailView: EpisodeDetailView,
                           didSelect character: RMCharacter) {
        
        let controller = CharacterDetailViewController(viewModel: .init(character: character))
        controller.navigationItem.title = character.name
        controller.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(controller, animated: true)
    }
}
