//
//  EpisodeListView.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 02/03/23.
//

import UIKit

protocol EpisodeListViewDelegate: AnyObject {
    func mrEpisodeListView(_ characterListView: EpisodeListView,
                             didSelectEpisode episode: Episode)
}

final class EpisodeListView: UIView {

    // MARK: - Properties

    public weak var delegate: EpisodeListViewDelegate?
    
    private let viewModel = EpisodeListViewViewModel()
    
    
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.register(CharacterEpisodeCollectionViewCell.self,
                                forCellWithReuseIdentifier: CharacterEpisodeCollectionViewCell.cellIndetifier)
        
        collectionView.register(FooterLoadingCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: FooterLoadingCollectionReusableView.identifier)
        return collectionView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        
        configureUI()
        spinner.startAnimating()
        viewModel.delegate = self
        viewModel.fetchEpisodes()
        setupCollectionView()
        setupConstraints()
    }
    
    // MARK: - Service
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        addSubviews(collectionView, spinner)
    }
    
    private func setupConstraints() {
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
    
    private func setupCollectionView() {
        collectionView.dataSource = viewModel
        collectionView.delegate = viewModel
    }
}

// MARK: - CharacterListViewViewModelDelegate

extension EpisodeListView: EpisodeListViewViewModelDelegate {
    func didLoadInitialEpisodes() {
        spinner.stopAnimating()
        collectionView.isHidden = false
        collectionView.reloadData() // Initial fetch character
    
        UIView.animate(withDuration: 0.4) {
            self.collectionView.alpha = 1
        }
    }
    
    func didLoadMoreEpisodes(with newIndexPaths: [IndexPath]) {
        collectionView.performBatchUpdates {
           self.collectionView.insertItems(at: newIndexPaths)
        }
    }
    
    func didSelectEpisode(_ episode: Episode) {
        delegate?.mrEpisodeListView(self, didSelectEpisode: episode)
    }
}

