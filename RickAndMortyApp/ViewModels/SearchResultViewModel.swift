//
//  SearchResultViewViewModel.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 28/09/23.
//

import Foundation

final class SearchResultViewModel {
    public private(set) var result: SearchResultType
    private var next: String?
    
    
    init(result: SearchResultType, next: String?) {
        self.result = result
        self.next = next
    }
    
    struct Info: Codable {
        let count: Int
        let pages: Int
        let prev: String?
    }
    
    private(set) var isLoadingMoreResults: Bool = false
    
    var shouldShowLoadingIndicator: Bool {
        return next != nil
    }
    
    func fetchAdditionalLocations(completion: @escaping ([LocationTableViewCellViewModel]) -> Void) {
        guard !isLoadingMoreResults else {
            return
        }
        isLoadingMoreResults = true
        
        guard let nextUrlString = next,
              let url = URL(string: nextUrlString) else { return }
        
        guard let request = AppRequest(url: url) else {
            isLoadingMoreResults = false
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
                var newResults: [LocationTableViewCellViewModel] = []
                strongSelf.next = info.next
                
                let additionalLocations = moreResults.compactMap({
                    LocationTableViewCellViewModel(location: $0)
                })
                
                switch strongSelf.result {
                case .locations(let existingLocations):
                    newResults = existingLocations + additionalLocations
                    strongSelf.result = .locations(newResults)
                    break
                case .episodes, .characters:
                    
                    break
                }
                
                DispatchQueue.main.async {
                    strongSelf.isLoadingMoreResults = false
                    completion(newResults)
                }
            case .failure(let failure):
                print(String(describing: failure))
                self?.isLoadingMoreResults = false
            }
        }
    }
    
    func fetchAdditionalResults(completion: @escaping ([any Hashable]) -> Void) {
        guard !isLoadingMoreResults else {
            return
        }
        isLoadingMoreResults = true
        
        guard let nextUrlString = next,
              let url = URL(string: nextUrlString) else { return }
        
        guard let request = AppRequest(url: url) else {
            isLoadingMoreResults = false
            return
        }
        
        switch result {
        case .characters(let existingResults):
            AppService.shared.execute(request, expecting: GetAllCharacterResponse.self) { [weak self] result in
                guard let strongSelf = self else {
                    return
                }
                switch result {
                case .success(let responseModel):
                    let moreResults = responseModel.results
                    let info = responseModel.info
                    var newResults: [CharacterCollectionViewCelltViewViewModel] = []
                    strongSelf.next = info.next
                    
                    let additionalResults = moreResults.compactMap({
                        CharacterCollectionViewCelltViewViewModel(characterName: $0.name,
                                                                  characterStatus: $0.status,
                                                                  characterImageUrl: URL(string: $0.image))
                    })
                    
                    newResults = existingResults + additionalResults
                    strongSelf.result = .characters(newResults)
                    
                    DispatchQueue.main.async {
                        strongSelf.isLoadingMoreResults = false
                        completion(newResults)
                    }
                case .failure(let failure):
                    print(String(describing: failure))
                    self?.isLoadingMoreResults = false
                }
            }
        case .locations:
            // table view case
            break
        case .episodes(let existingResults):
            AppService.shared.execute(request, expecting: GetAllEpisodesResponse.self) { [weak self] result in
                guard let strongSelf = self else {
                    return
                }
                switch result {
                case .success(let responseModel):
                    let moreResults = responseModel.results
                    let info = responseModel.info
                    var newResults: [CharacterEpisodesCollectionViewCellViewModel] = []
                    strongSelf.next = info.next
                    
                    let additionalResults = moreResults.compactMap({
                        CharacterEpisodesCollectionViewCellViewModel(episodeDataUrl: URL(string: $0.url))
                    })
                    
                    newResults = existingResults + additionalResults
                    strongSelf.result = .episodes(newResults)
                    
                    DispatchQueue.main.async {
                        strongSelf.isLoadingMoreResults = false
                        completion(newResults)
                    }
                case .failure(let failure):
                    print(String(describing: failure))
                    self?.isLoadingMoreResults = false
                }
            }
        }
        
        
    }
}

enum SearchResultType {
    case characters([CharacterCollectionViewCelltViewViewModel])
    case locations([LocationTableViewCellViewModel])
    case episodes([CharacterEpisodesCollectionViewCellViewModel])
}
