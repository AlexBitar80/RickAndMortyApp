//
//  EpisodeDetailView.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 24/02/23.
//

import UIKit

final class EpisodeDetailView: UIView {
    
    // MARK: - Properties
    
    private var viewModel: EpisodeDetailViewViewModel?
    
    private var collectionView: UICollectionView?
    
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        configureUI()
//        addConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        backgroundColor = .red
//        self.collectionView = createCollectionView()
    }
    
//    private func addConstraint() {
//        NSLayoutConstraint.activate([
//
//        ])
//    }
//
//    private func createCollectionView() -> UICollectionView {
//
//    }
    
    public func configure(with viewModel: EpisodeDetailViewViewModel) {
        self.viewModel = viewModel
    }
}
