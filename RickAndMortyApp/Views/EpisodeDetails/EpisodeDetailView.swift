//
//  EpisodeDetailView.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 24/02/23.
//

import UIKit

protocol EpisodeDetailViewDelegate: AnyObject {
    func episodeDetailView(_ detailView: EpisodeDetailView,
                           didSelect character: RMCharacter)
}

final class EpisodeDetailView: UIView {
    
    // MARK: - Properties
    
    private var viewModel: EpisodeDetailViewViewModel? {
        didSet {
            spinner.stopAnimating()
            self.collectionView.isHidden = false
            self.collectionView.reloadData()
            UIView.animate(withDuration: 0.3) {
                self.collectionView.alpha = 1
            }
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { section, _ in
            return self.collectionLayout(for: section)
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(EpisodeInfoCollectionViewCell.self,
                                forCellWithReuseIdentifier: EpisodeInfoCollectionViewCell.cellIdentifier)
        collectionView.register(CharacterCollectionViewCell.self,
                                forCellWithReuseIdentifier: CharacterCollectionViewCell.cellIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    public weak var delegate: EpisodeDetailViewDelegate?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        configureUI()
        addConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        backgroundColor = .systemBackground
        addSubviews(collectionView, spinner)
        spinner.startAnimating()
    }
    
    private func addConstraint() {
        NSLayoutConstraint.activate([
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    public func configure(with viewModel: EpisodeDetailViewViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: - UICollectionViewDelegate

extension EpisodeDetailView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let viewModel = viewModel else { return }
        
        let sections = viewModel.cellViewModels
        
        let sectionType = sections[indexPath.section]
        
        switch sectionType {
        case .information:
            break
        case .characters:
            guard let character = viewModel.character(at: indexPath.row) else { return }
            self.delegate?.episodeDetailView(self, didSelect: character)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension EpisodeDetailView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.cellViewModels.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sections = viewModel?.cellViewModels else { return 0 }
        
        let sectionType = sections[section]
        
        switch sectionType {
        case .information(let viewModels):
            return viewModels.count
        case .characters(let viewModels):
            return viewModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let sections = viewModel?.cellViewModels else { fatalError("no viewModel") }
        
        let sectionType = sections[indexPath.section]
        
        switch sectionType {
        case .information(let viewModels):
            let cellViewModel = viewModels[indexPath.row]
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: EpisodeInfoCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? EpisodeInfoCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: cellViewModel)
            
            return cell
        case .characters(let viewModels):
            let cellViewModel = viewModels[indexPath.row]
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CharacterCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? CharacterCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: cellViewModel)
            
            return cell
        }
    }
}

// MARK: - Layout

extension EpisodeDetailView {
    private func collectionLayout(for section: Int) -> NSCollectionLayoutSection {
        guard let sections = viewModel?.cellViewModels else { return createInfoLayout() }
        
        switch sections[section] {
        case .information:
            return createInfoLayout()
        case .characters:
            return createCharacterLayout()
        }
    }
    
    private func createInfoLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .fractionalHeight(1)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                       heightDimension: .absolute(80)),
                                                     subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    private func createCharacterLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5),
                                                            heightDimension: .fractionalHeight(1)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                                                                       heightDimension: .absolute(260)),
                                                     subitems: [item, item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
}
