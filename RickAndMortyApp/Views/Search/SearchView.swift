//
//  SearchView.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 13/08/23.
//

import UIKit

final class SearchView: UIView {
    
    // MARK: - Propeties

    private let viewModel: SearchViewViewModel
    
    // MARK: - Subviews
    
    private let searchInputView = SearchInputView()
    
    private let noResultsView = NoSearchResultsView()
    
    // MARK: - Init
    
    init(frame: CGRect, viewModel: SearchViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        configureUI()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        backgroundColor = .systemBackground
        addSubviews(noResultsView, searchInputView)
        searchInputView.configure(with: SearchInputViewViewModel(type: viewModel.config.type))
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            
            // - inputView
            
            searchInputView.topAnchor.constraint(equalTo: topAnchor),
            searchInputView.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchInputView.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchInputView.heightAnchor.constraint(equalToConstant: 110),
            
            // - noResultsView
            
            noResultsView.heightAnchor.constraint(equalToConstant: 150),
            noResultsView.widthAnchor.constraint(equalToConstant: 150),
            noResultsView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noResultsView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}

extension SearchView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension SearchView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
}
