//
//  SearchViewViewModel.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 13/08/23.
//

import Foundation

class SearchViewViewModel {
    
    // MARK: - Properties
    
    let config: SearchViewController.Config
    
    private var optionMap: [SearchInputViewViewModel.DynamicOption: String] = [:]
    private var searchText = ""
    
    private var optionMapUpdateBlock: (((SearchInputViewViewModel.DynamicOption, String)) -> Void)?
    
    private var serchResultHandler: ((SearchResultViewViewModel) -> Void)?
    
    private var noResultsHandler: (() -> Void)?
    
    private var searchResultModel: Codable?
    
    // MARK: - Init
    
    init(config: SearchViewController.Config) {
        self.config = config
    }
    
    // MARK: - Helpers
    
    func registerSearchResultHandler(_ block: @escaping (SearchResultViewViewModel) -> Void) {
        self.serchResultHandler = block
    }
    
    func registerNoResulstHandler(_ block: @escaping () -> Void) {
        self.noResultsHandler = block
    }
    
    func set(query text: String) { 
        self.searchText = text
    }
    
    func executeSearch() {
        
        var queryParams: [URLQueryItem] = [
            URLQueryItem(name: "name", value: searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
        ]
        
        queryParams.append(contentsOf: optionMap.enumerated().compactMap({ _, element in
            let key: SearchInputViewViewModel.DynamicOption = element.key
            let value: String = element.value
            
            return URLQueryItem(name: key.queryArgumentes, value: value)
        }))
        
        let request = AppRequest(endpoint: config.type.endpoint,
                                 queryParameters: queryParams)
        
        switch config.type.endpoint {
        case .character:
            makeSearchAPICall(GetAllCharacterResponse.self, request: request)
        case .location:
            makeSearchAPICall(GetAllLocationsResponse.self, request: request)
        case .episode:
            makeSearchAPICall(GetAllEpisodesResponse.self, request: request)
        }
    }
    
    private func makeSearchAPICall<T: Codable>(_ type: T.Type, request: AppRequest) {
        AppService.shared.execute(request, expecting: type) { [weak self] result in
            switch result {
            case .success(let model):
                self?.processSearchResults(model: model)
            case .failure:
                self?.handlerNoResults()
            }
        }
    }
    
    private func processSearchResults(model: Codable) {
        var resultVM: SearchResultViewViewModel?
        
        if let characterResults = model as? GetAllCharacterResponse {
            resultVM = .characters( characterResults.results.compactMap({
                
                return CharacterCollectionViewCelltViewViewModel(characterName: $0.name,
                                                                 characterStatus: $0.status,
                                                                 characterImageUrl: URL(string: $0.image))
            }))
        } else if let locationsResults = model as? GetAllLocationsResponse {
            resultVM = .locations(locationsResults.results.compactMap({
                return LocationTableViewCellViewModel(location: $0)
            }))
        } else if let episodesResults = model as? GetAllEpisodesResponse {
            resultVM = .episodes(episodesResults.results.compactMap({
                return CharacterEpisodesCollectionViewCellViewModel(episodeDataUrl: URL(string: $0.url))
            }))
        }
                
        if let results = resultVM {
            self.searchResultModel = model
            self.serchResultHandler?(results)
        } else {
            self.handlerNoResults()
        }
    }
    
    private func handlerNoResults() {
        print("No results")
        noResultsHandler?()
    }
    
    func set(value: String, for option: SearchInputViewViewModel.DynamicOption) {
        optionMap[option] = value
        let tuple = (option, value)
        optionMapUpdateBlock?(tuple)
    }
    
    func registerChageBlock(_ block: @escaping ((SearchInputViewViewModel.DynamicOption, String)) -> Void) {
        self.optionMapUpdateBlock = block
    }
    
    func locationSearchResult(at index: Int) -> Location? {
        guard let searchModel = searchResultModel as? GetAllLocationsResponse else { return nil }
        return searchModel.results[index]
    }
}
