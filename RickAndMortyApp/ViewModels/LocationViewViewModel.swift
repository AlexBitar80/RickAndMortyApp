//
//  LocationViewViewModel.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 12/07/23.
//

import Foundation

// MARK: - LocationViewViewModelDelegate

protocol LocationViewViewModelDelegate: AnyObject {
    func didFetchInitialLocations()
}

final class LocationViewViewModel {
    
    weak var delegate: LocationViewViewModelDelegate?
    
    // MARK: - Private Properties
    
    private var locations: [Location] = [] {
        didSet {
            for location in locations {
                let cellViewModel = LocationTableViewCellViewModel(location: location)
                if !cellViewModels.contains(cellViewModel) {
                    cellViewModels.append(cellViewModel)
                }
            }
        }
    }
    private(set) var cellViewModels: [LocationTableViewCellViewModel] = []
    private var apiInfo: GetAllLocationsResponseInfo?
    
    // MARK: - Init
    
    init() {}
    
    // MARK: - Methods
    
    func fetchLocations() {
        AppService.shared.execute(.listLocationRequest,
                                  expecting: GetAllLocationsResponse.self) { [weak self] result in
            switch result {
            case .success(let location):
                self?.apiInfo = location.info
                self?.locations = location.results ?? []
                DispatchQueue.main.async {
                    self?.delegate?.didFetchInitialLocations()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - Private Methods
    
    private var hasMoreResults: Bool {
        return false
    }
}
