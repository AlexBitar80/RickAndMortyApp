//
//  LocationDetailViewViewModel.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 12/08/23.
//

import Foundation

protocol LocationDetailViewViewModelDelegate: AnyObject {
    func didFetchLocationDetails()
}

final class LocationDetailViewViewModel {
    // MARK: - Properties
    
    private let endpointUrl: URL?
    
    private var dataTuple: (location: Location, characters: [RMCharacter])? {
        didSet {
            createCellViewModels()
            delegate?.didFetchLocationDetails()
        }
    }
    
    enum SectionType {
        case information(viewModels: [EpisodeInfoCollectionViewCellViewModel])
        case characters(viewModels: [CharacterCollectionViewCelltViewViewModel])
    }
    
    public weak var delegate: LocationDetailViewViewModelDelegate?
    
    public private(set) var cellViewModels: [SectionType] = []
    
    // MARK: - Init
    
    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
    }
    
    // MARK: - Helpers
    
    /// Public methods

    public func fetchLocationData() {
        guard let url = endpointUrl, let request = AppRequest(url: url) else { return }
        
        AppService.shared.execute(request, expecting: Location.self) { [weak self] result in
            switch result {
            case .success(let model):
                self?.fetchRelatedCharacters(location: model)
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
        guard let location = dataTuple?.location,
              let characters = dataTuple?.characters,
              let locationName = location.name,
              let dimension = location.dimension,
              let type = location.type,
              let createdEpisode = location.created else { return }
        
        var createdString = createdEpisode
        if let date = CharacterInfoCollectionViewCellViewModel.dateFormatter.date(from: createdString) {
            createdString = CharacterInfoCollectionViewCellViewModel.shortDateFormatter.string(from: date)
        }
        
        cellViewModels = [
            .information(viewModels: [
                .init(title: "Location Name", value: locationName),
                .init(title: "Type", value: type),
                .init(title: "Dimension", value: dimension),
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
    
    private func fetchRelatedCharacters(location: Location) {
        guard let characters = location.residents else { return }
        
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
                location: location,
                characters: charactersCount
            )
        }
    }
}
