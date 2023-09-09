//
//  SearchInputView.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 13/08/23.
//

import UIKit

// MARK: - SearchInputViewDelegate

protocol SearchInputViewDelegate: AnyObject {
    func searchInputView(_ input: SearchInputView,
                         didSelect option: SearchInputViewViewModel.DynamicOption)
}

final class SearchInputView: UIView {
    
    // MARK: - Properties
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    weak var delegate: SearchInputViewDelegate?
    
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
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 58)
        ])
    }
    
    func configure(with viewModel: SearchInputViewViewModel) {
        searchBar.placeholder = viewModel.searchPlaceholderText
        // TODO: Fix height of input view for episode with no options
        self.viewModel = viewModel
    }
    
    private func createOptionStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        return stackView
    }
    
    private func createOptionSelectionViews(options: [SearchInputViewViewModel.DynamicOption]) {
        let stackView = createOptionStackView()
        
        for x in 0..<options.count {
            let option = options[x]
            let button = createButton(with: option, tag: x)
            stackView.addArrangedSubview(button)
        }
    }
    
    private func createButton(with option: SearchInputViewViewModel.DynamicOption, tag: Int) -> UIButton {
        let buttonOptions = UIButton()
        buttonOptions.backgroundColor = .secondarySystemFill
        
        buttonOptions.setAttributedTitle(NSAttributedString(string: option.rawValue, attributes: [
            .font: UIFont.systemFont(ofSize: 18, weight: .medium),
            .foregroundColor: UIColor.label
        ]), for: .normal)
        
        buttonOptions.translatesAutoresizingMaskIntoConstraints = false
        buttonOptions.tag = tag
        buttonOptions.layer.cornerRadius = 6
        buttonOptions.addTarget(self, action: #selector(didTapButtonOptions(_:)), for: .touchUpInside)
        
        return buttonOptions
    }
    
    @objc private func didTapButtonOptions(_ sender: UIButton) {
        guard let options = viewModel?.options else { return }
        let tag = sender.tag
        let selected = options[tag]
        delegate?.searchInputView(self, didSelect: selected)
    }
    
    func presentKeyboard() {
        searchBar.becomeFirstResponder()
    }
}
