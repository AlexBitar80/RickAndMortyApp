//
//  SearchViewController.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 07/03/23.
//

import UIKit

final class SearchViewController: UIViewController {

    // MARK: - Properties
    
    struct Config {
        enum `Type` {
            case character
            case location
            case episode
            
            var title: String {
                switch self {
                case .episode:
                    return "Search Episodes"
                case .character:
                    return "Search Characters"
                case .location:
                    return "Search Locations"
                }
            }
        }
        
        let type: `Type`
    }
    
    private let viewModel: SearchViewViewModel
    private let searchView: SearchView
    
    // MARK: - Init
    
    init(config: Config) {
        let viewModel = SearchViewViewModel(config: config)
        self.viewModel = viewModel
        self.searchView = SearchView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        addConstraints()
        searchView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        searchView.presentKeyboard()
    }

    // MARK: - Helpers

    private func configureUI() {
        view.backgroundColor = .systemBackground
        title = viewModel.config.type.title
        
        view.addSubview(searchView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapExecuteSearch))
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            searchView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    @objc private func didTapExecuteSearch() {
        
    }
}

// MARK: - SearchViewDelegate

extension SearchViewController: SearchViewDelegate {
    func searchView(_ view: SearchView,
                    didSelectOption option: SearchInputViewViewModel.DynamicOption) {
        print("Should present option picker")
    }
}
