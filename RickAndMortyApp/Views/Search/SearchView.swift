//
//  SearchView.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 13/08/23.
//

import UIKit

protocol SearchViewDelegate: AnyObject {
    func searchView(_ view: SearchView,
                    didSelectOption option: SearchInputViewViewModel.DynamicOption)
}

final class SearchView: UIView {
    
    // MARK: - Propeties

    weak var delegate: SearchViewDelegate?
    
    private let viewModel: SearchViewViewModel
    
    // MARK: - Subviews
    
    private let searchInputView = SearchInputView()
    
    private let noResultsView = NoSearchResultsView()
    
    private let resultsView = SearchResultsView()
    
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
        addSubviews(resultsView, noResultsView, searchInputView)
        searchInputView.configure(with: SearchInputViewViewModel(type: viewModel.config.type))
        searchInputView.delegate = self
      
        setUpHandlers(viewModel: viewModel)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            
            // - inputView
            
            searchInputView.topAnchor.constraint(equalTo: topAnchor),
            searchInputView.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchInputView.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchInputView.heightAnchor.constraint(equalToConstant: viewModel.config.type == .episode ? 55 : 110),
            
            // - resultsView
            
            resultsView.topAnchor.constraint(equalTo: searchInputView.bottomAnchor),
            resultsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            resultsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            resultsView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // - noResultsView
            
            noResultsView.heightAnchor.constraint(equalToConstant: 150),
            noResultsView.widthAnchor.constraint(equalToConstant: 150),
            noResultsView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noResultsView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    func presentKeyboard() {
        searchInputView.presentKeyboard()
    }
    
    private func setUpHandlers(viewModel: SearchViewViewModel) {
        viewModel.registerChageBlock { [weak self] tuple in
            self?.searchInputView.update(option: tuple.0, value: tuple.1)
        }
        
        viewModel.registerSearchResultHandler { [weak self] results in
            DispatchQueue.main.async {
                self?.resultsView.configure(with: results)
                self?.noResultsView.isHidden = true
                self?.resultsView.isHidden = false
            }
        }
        
        viewModel.registerNoResulstHandler { [weak self] in
            DispatchQueue.main.async {
                self?.noResultsView.isHidden = false
                self?.resultsView.isHidden = true
            }
        }
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

// MARK: - SearchInputViewDelegate

extension SearchView: SearchInputViewDelegate {
    func searchInputViewDidTapSearchKeyboardButton(_ input: SearchInputView) {
        viewModel.executeSearch()
    }
    
    func searchInputView(_ input: SearchInputView, didChangeSearchText text: String?) {
        if let text {
            viewModel.set(query: text)
        }
    }
    
    func searchInputView(_ input: SearchInputView,
                         didSelect option: SearchInputViewViewModel.DynamicOption) {
        delegate?.searchView(self, didSelectOption: option)
    }
}
