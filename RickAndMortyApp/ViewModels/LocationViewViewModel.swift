//
//  LocationViewViewModel.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 12/07/23.
//

import Foundation

final class LocationViewViewModel {
    
    private let locations: [Location] = []
    
    init() {}
    
    private let cellViewModels: [String] = []
    
    func fetchLocations() {
        AppService.shared.execute(.listLocationRequest, expecting: String.self) { result in
            switch result {
            case .success(let location):
                print(location)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private var hasMoreResults: Bool {
        return false
    }
}
