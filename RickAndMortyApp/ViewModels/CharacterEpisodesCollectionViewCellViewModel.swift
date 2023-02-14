//
//  CharacterEpisodesCollectionViewCellViewModel.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 10/02/23.
//

import Foundation

protocol EpisodeDataRender {
    var name: String? { get }
    var air_date: String? { get }
    var episode: String? { get }
}

final class CharacterEpisodesCollectionViewCellViewModel {
    
    // MARK: - Properties
    
    private let episodeDataUrl: URL?
    private var isFetching = false
    private var dataBlock: ((EpisodeDataRender) -> Void)?
    
    private var episode: Episode? {
        didSet {
            guard let model = episode else { return }
            
            self.dataBlock?(model)
        }
    }
    
    // MARK: - Init
    
    init(episodeDataUrl: URL?) {
        self.episodeDataUrl = episodeDataUrl
    }
    
    // MARK: - Public
    
    public func registerForData(_ block: @escaping (EpisodeDataRender) -> Void) {
        self.dataBlock = block
    }
    
    public func fetchEpisode() {
        guard !isFetching else {
            if let model = episode {
                self.dataBlock?(model)
            }
            
            return
        }
        
        guard let url = episodeDataUrl,
              let request = AppRequest(url: url) else {
            
            return
        }
        
        isFetching = true
        
        AppService.shared.execute(request, expecting: Episode.self) { [weak self] result in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    self?.episode = model
                }
            case .failure(let failure):
                print(String(describing: failure))
            }
        }
    }
}
