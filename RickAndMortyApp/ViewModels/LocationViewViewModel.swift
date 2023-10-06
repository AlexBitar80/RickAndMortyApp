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
    
    var shouldShowLoadMoreIndicator: Bool {
            return apiInfo?.next != nil
        }
        
    private var didFinishPagination: (() -> Void)?
    
    var isLoadingMoreLocations: Bool = false
    
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
    
    func registerDidFinishPaginationBlock(_ block: @escaping () -> Void) {
        self.didFinishPagination = block
    }
    
    public func fetchAdditionalLocations() {
        
        guard !isLoadingMoreLocations else {
            return
        }
        isLoadingMoreLocations = true
        
        guard let nextUrlString = apiInfo?.next,
              let url = URL(string: nextUrlString) else { return }
        
        guard let request = AppRequest(url: url) else {
            isLoadingMoreLocations = false
            return
        }
        
        AppService.shared.execute(request, expecting: GetAllLocationsResponse.self) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel.results
                let info = responseModel.info
                strongSelf.apiInfo = info
                strongSelf.cellViewModels.append(contentsOf: moreResults.compactMap({
                    LocationTableViewCellViewModel(location: $0)
                }))
                DispatchQueue.main.async {
                    strongSelf.isLoadingMoreLocations = false
                    
                    strongSelf.didFinishPagination?()
                }
            case .failure(let failure):
                print(String(describing: failure))
                self?.isLoadingMoreLocations = false
            }
        }
    }

    
    func location(at index: Int) -> Location? {
        
        guard index < locations.count, index >= 0 else { return nil }
        
        return self.locations[index]
    }
    
    func fetchLocations() {
        AppService.shared.execute(.listLocationRequest,
                                  expecting: GetAllLocationsResponse.self) { [weak self] result in
            switch result {
            case .success(let location):
                self?.apiInfo = location.info
                self?.locations = location.results
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
