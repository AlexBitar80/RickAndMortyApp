//
//  EpisodiesViewController.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 07/01/23.
//

import UIKit

final class EpisodesViewController: UIViewController {

    // MARK: - Properties
    
    private lazy var episodeListView: EpisodeListView = {
        let view = EpisodeListView()
        return view
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupDelegate()
        setupConstraints()
        addSearchButton()
    }
    
    // MARK: - Helpers
    
    private func setupDelegate() {
        episodeListView.delegate = self
    }
    
    private func configureUI() {
        title = "Episodes"
        view.backgroundColor = .systemBackground
        view.addSubview(episodeListView)
    }
    
    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                                            target: self,
                                                            action: #selector(didTapSearch))
    }
    
    @objc private func didTapSearch() {
        let viewControllet = SearchViewController(config: .init(type: .episode))
        viewControllet.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(viewControllet, animated: true)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            episodeListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            episodeListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            episodeListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            episodeListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

// MARK: - CharacterListViewDelegate

extension EpisodesViewController: EpisodeListViewDelegate {
    func mrEpisodeListView(_ characterListView: EpisodeListView,
                           didSelectEpisode episode: Episode) {
        
        let detailViewController = EpisodeDetailViewController(url: URL(string: episode.url))
        detailViewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
