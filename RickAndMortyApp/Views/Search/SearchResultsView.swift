//
//  SearchResultsView.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 28/09/23.
//

import UIKit

// MARK: - SearchResultsViewDelegate

protocol SearchResultsViewDelegate: AnyObject {
    func searchResultsView(_ searchResultsView: SearchResultsView, didTapLocationAt index: Int)
}

final class SearchResultsView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: SearchResultsViewDelegate?
    
    private var viewModel: SearchResultViewViewModel? {
        didSet {
            self.processViewModel()
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(LocationTableViewCell.self,
                           forCellReuseIdentifier: LocationTableViewCell.identifier)
        tableView.isHidden = true
        return tableView
    }()
    
    private var locationCellViewModels: [LocationTableViewCellViewModel] = []
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        isHidden = true
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .red
       
        
        addSubviews(tableView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func processViewModel() {
        guard let viewModel else { return }
        
        switch viewModel {
        case .characters(let viewModels):
            setUpCollectionView()
        case .episodes(let viewModels):
            setUpCollectionView()
        case .locations(let viewModels):
            setUpTableView(viewModels: viewModels)
        }
    }
    
    private func setUpCollectionView() {
        
    }
    
    private func setUpTableView(viewModels: [LocationTableViewCellViewModel]) {
        tableView.isHidden = false
        tableView.delegate = self
        tableView.dataSource = self
        
        self.locationCellViewModels = viewModels
        tableView.reloadData()
    }
    
    func configure(with viewModel: SearchResultViewViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: - UITableViewDelegate

extension SearchResultsView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        locationCellViewModels.count
    }
}

// MARK: - UITableViewDataSource

extension SearchResultsView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.identifier,
                                                       for: indexPath) as? LocationTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: locationCellViewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.searchResultsView(self, didTapLocationAt: indexPath.row)
    }
}
