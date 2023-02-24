//
//  EpisodeDetailViewViewModel.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 24/02/23.
//

import Foundation

class EpisodeDetailViewViewModel {
    // MARK: - Properties
    
    private let endpointUrl: URL?
    
    // MARK: - Init
    
    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
        fetchEpisodeData()
    }
    
    // MARK: - Helpers
    
    private func fetchEpisodeData() {
        guard let url = endpointUrl, let request = AppRequest(url: url) else { return }
        
        AppService.shared.execute(request, expecting: Episode.self) { result in
            switch result {
            case .success(let success):
                print(String(describing: success))
            case .failure:
                break
            }
        }
    }
}
