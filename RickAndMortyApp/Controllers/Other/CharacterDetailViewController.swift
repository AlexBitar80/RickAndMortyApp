//
//  CharacterDetailViewController.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 25/01/23.
//

import UIKit

final class CharacterDetailViewController: UIViewController {

    // MARK: - Properties
    
    private let viewModel: CharacterDetailViewViewModel
    
    private let detailView = CharacterDetailView()
    
    // MARK: - Init
    
    init(viewModel: CharacterDetailViewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        setupConstraints()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        title = viewModel.title
        view.addSubview(detailView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self,
                                                            action: #selector(didTapShare))

    }
    
    @objc private func didTapShare() {
        // TODO: - Share character info
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            detailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
