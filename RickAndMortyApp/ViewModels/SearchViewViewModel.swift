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
    
    // MARK: - Init
    
    init(config: SearchViewController.Config) {
        self.config = config
    }
    
    // MARK: - Helpers
    
    func set(query text: String) {
        self.searchText = text
    }
    
    func executeSearch() {
        // Create request besed on filters
        // Send API call
        // Notify view of results, no resultes, or error
    }
    
    func set(value: String, for option: SearchInputViewViewModel.DynamicOption) {
        optionMap[option] = value
        let tuple = (option, value)
        optionMapUpdateBlock?(tuple)
    }
    
    func registerChageBlock(_ block: @escaping ((SearchInputViewViewModel.DynamicOption, String)) -> Void) {
        self.optionMapUpdateBlock = block
    }
}
