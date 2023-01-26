//
//  CharacterViewController.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 07/01/23.
//

import UIKit

final class CharacterViewController: UIViewController {

    // MARK: - Properties
    
    private lazy var characterListView: CharacterListView = {
        let view = CharacterListView()
        return view
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Characters"
        view.backgroundColor = .systemBackground
        configureUI()
        setupDelegate()
        setupConstraints()
    }
    
    // MARK: - Helpers
    
    private func setupDelegate() {
        characterListView.delegate = self
    }
    
    private func configureUI() {
        view.addSubview(characterListView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            characterListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            characterListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            characterListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            characterListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

// MARK: - CharacterListViewDelegate

extension CharacterViewController: CharacterListViewDelegate {
    func mrCharacterListView(_ characterListView: CharacterListView,
                             didSelectCharacter character: RMCharacter) {
        
        let viewModel = CharacterDetailViewViewModel(character: character)
        let detailViewController = CharacterDetailViewController(viewModel: viewModel)
        detailViewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
 
