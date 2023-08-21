//
//  SearchInputView.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 13/08/23.
//

import UIKit

final class SearchInputView: UIView {
    
    // MARK: - Properties
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private var viewModel: SearchInputViewViewModel? {
        didSet {
            guard let viewModel = viewModel, viewModel.hasDynamicOptions else {
                return
            }
            
            let options = viewModel.options
            createOptionSelectionViews(options: options)
        }
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
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
        addSubviews(searchBar)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    func configure(with viewModel: SearchInputViewViewModel) {
        searchBar.placeholder = viewModel.searchPlaceholderText
        // TODO: Fix height of input view for episode with no options
        self.viewModel = viewModel
    }
    
    private func createOptionSelectionViews(options: [SearchInputViewViewModel.DynamicOption]) {
        for option in options {
            print(option.rawValue)
        }
    }
}
