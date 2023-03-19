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
    
    private func createCellViewModels() {
        guard let episode = dataTuple?.episode,
              let characters = dataTuple?.characters,
              let episodeName = episode.name,
              let episodeAirData = episode.air_date,
              let episodeSeason = episode.episode,
              let createdEpisode = episode.created else { return }
                
        cellViewModels = [
            .information(viewModels: [
                .init(title: "Episode Name", value: episodeName),
                .init(title: "Air Date", value: episodeAirData),
                .init(title: "Episode", value: episodeSeason),
                .init(title: "Created", value: createdEpisode)
            ]),
            .characters(viewModels: characters.compactMap({ character in
                guard let name = character.name,
                      let status = character.status,
                      let imageUrl = URL(string: character.image ?? "") else { return nil }
                    
                return CharacterCollectionViewCelltViewViewModel(characterName: name,
                                                                 characterStatus: status,
                                                                 characterImageUrl: imageUrl)
            }))
        ]
    }
    
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
                episode: episode,
                characters: charactersCount
            )
        }
    }
}
