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
    
    private var dataTuple: (episode: Episode, characters: [RMCharacter])? {
        didSet {
            createCellViewModels()
            delegate?.didFetchEpisodeDetails()
        }
    }
    
    enum SectionType {
        case information(viewModels: [EpisodeInfoCollectionViewCellViewModel])
        case characters(viewModels: [CharacterCollectionViewCelltViewViewModel])
    }
    
    public weak var delegate: EpisodeDetailViewViewModelDelegate?
    
    public private(set) var cellViewModels: [SectionType] = []
    
    // MARK: - Init
    
    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
    }
    
    // MARK: - Helpers
    
    /// Public methods
    
    public func fetchEpisodeData() {
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
    
    public func character(at index: Int) -> RMCharacter? {
        guard let dataTuple else { return nil }
        
        return dataTuple.characters[index]
    }
    
    /// Private methods
    
    private func createCellViewModels() {
        guard let dataTuple = dataTuple else {
            return
        }
        
        let episode = dataTuple.episode
        
        var createdString = episode.created
        if let date = CharacterInfoCollectionViewCellViewModel.dateFormatter.date(from: episode.created) {
            createdString = CharacterInfoCollectionViewCellViewModel.shortDateFormatter.string(from: date)
        }
        
        cellViewModels = [
            .information(viewModels: [
                .init(title: "Episode Name", value: episode.name),
                .init(title: "Air Date", value: episode.air_date),
                .init(title: "Episode", value: episode.episode),
                .init(title: "Created", value: createdString),
            ]),
            .characters(viewModels: dataTuple.characters.compactMap({ character in
                return CharacterCollectionViewCelltViewViewModel(
                    characterName: character.name,
                    characterStatus: character.status,
                    characterImageUrl: URL(string: character.image)
                )
            }))
        ]
    }
    
    private func fetchRelatedCharacters(episode: Episode) {
        let requests: [AppRequest] = episode.characters.compactMap({
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
                episode: episode,
                characters: charactersCount
            )
        }
    }
}
