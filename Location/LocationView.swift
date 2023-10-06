//
//  LocationView.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 12/07/23.
//

import UIKit

// MARK: - LocationViewDelegate

protocol LocationViewDelegate: AnyObject {
    func rmLocationView(_ locationView: LocationView, didSelect location: Location)
}

final class LocationView: UIView {
    
    // MARK: - Properties
    
    weak var delgate: LocationViewDelegate?
    
    private var viewModel: LocationViewViewModel? {
        didSet {
            spinner.stopAnimating()
            tableView.isHidden = false
            tableView.reloadData()
            UIView.animate(withDuration: 0.3) {
                self.tableView.alpha = 1
            }
            
            viewModel?.registerDidFinishPaginationBlock { [weak self] in
                DispatchQueue.main.async {
                    self?.tableView.tableFooterView = nil
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.alpha = 0
        tableView.isHidden = true
        tableView.register(LocationTableViewCell.self,
                           forCellReuseIdentifier: LocationTableViewCell.identifier)
        return tableView
    }()
    
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = .white
        return spinner
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        
        configureUI()
        configureTableView()
        addconstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func configureUI() {
        addSubviews(tableView, spinner)
    }
    
    private func addconstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configure(with viewModel: LocationViewViewModel) {
        self.viewModel = viewModel
    }
}

extension LocationView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let locationModel = viewModel?.location(at: indexPath.row) else { return }
       
        self.delgate?.rmLocationView(self,
                                     didSelect: locationModel)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension LocationView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.cellViewModels.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellViewModels = viewModel?.cellViewModels else { fatalError() }
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: LocationTableViewCell.identifier
        ) as? LocationTableViewCell else { return UITableViewCell() }
        
        let cellViewModel = cellViewModels[indexPath.row]
        
        cell.configure(with: cellViewModel)
        
        return cell
    }
}

// MARK: - UIScrollViewDelegate

extension LocationView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let viewModel = viewModel,
              !viewModel.cellViewModels.isEmpty,
              !viewModel.isLoadingMoreLocations,
              viewModel.shouldShowLoadMoreIndicator else { return }
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollVieFixedHeight = scrollView.frame.size.height
            
            if offset >= (totalContentHeight - totalScrollVieFixedHeight - 120) {
                DispatchQueue.main.async {
                    self?.showLoadingIndicator()
                }
                
                viewModel.fetchAdditionalLocations()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    self?.tableView.reloadData()
                })
            }
            
            t.invalidate()
        }
    }
    
    private func showLoadingIndicator() {
        let footer = TableLoadingFooterView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 100))
        
        tableView.tableFooterView = footer
    }
}
