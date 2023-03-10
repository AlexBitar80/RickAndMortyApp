//
//  EpisodeDetailViewViewModel.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 24/02/23.
//

import Foundation

protocol EpisodeDetailViewViewModelDelegate: AnyObject {
    func didFetchEpisodeDetails()
}

final class EpisodeDetailViewViewModel {
    // MARK: - Properties
    
    private let endpointUrl: URL?
    
    private var dataTuple: (Episode, [RMCharacter])? {
        didSet {
            delegate?.didFetchEpisodeDetails()
        }
    }
    
    public weak var delegate: EpisodeDetailViewViewModelDelegate?
    
    // MARK: - Init
    
    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
    }
    
    // MARK: - Helpers
    
    func fetchEpisodeData() {
        guard let url = endpointUrl, let request = AppRequest(url: url) else { return }
        
        AppService.shared.execute(request, expecting: Episode.self) { [weak self] result in
            switch result {
            case .success(let model):
                self?.fetchRelatedCharacters(episode: model)
            case .failure:
                break
            }
        }
    }
    
    private func fetchRelatedCharacters(episode: Episode) {
        guard let characters = episode.characters else { return }
        
        let requests: [AppRequest] = characters.compactMap({
           return URL(string: $0)
        }).compactMap({
            return AppRequest(url: $0)
        })
        
        let group = DispatchGroup()
        var charactersCount: [RMCharacter] = []
        for request in requests {
            group.enter()
            AppService.shared.execute(request, expecting: RMCharacter.self) { result in
                defer {
                    group.leave()
                }
                
                switch result {
                case .success(let model):
                    charactersCount.append(model)
                case .failure:
                    break
                }
            }
        }
        
        group.notify(queue: .main) {
            self.dataTuple = (
                episode,
                charactersCount
            )
        }
    }
}
