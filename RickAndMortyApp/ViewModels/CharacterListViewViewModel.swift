//
//  CharacterListViewViewModel.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 23/01/23.
//

import Foundation
import UIKit

protocol CharacterListViewViewModelDelegate: AnyObject {
    func didLoadInitialCharacters()
    func didSelectCharacter(_ character: RMCharacter)
}

final class CharacterListViewViewModel: NSObject {
    
    // MARK: - Properties
    
    public weak var delegate: CharacterListViewViewModelDelegate?
    
    private var characters: [RMCharacter] = [] {
        didSet {
            for character in characters {
                guard let name = character.name,
                      let status = character.status,
                      let image = character.image else { return }
                
                let viewModel = CharacterCollectionViewCelltViewViewModel(characterName: name,
                                                                          characterStatus: status,
                                                                          characterImageUrl: URL(string: image))
                
                cellsViewModels.append(viewModel)
            }
        }
    }
    
    private var cellsViewModels: [CharacterCollectionViewCelltViewViewModel] = []
    
    private var apiInfo: GetAllCharacterResponseInfo? = nil
    
    public func fetchCharacters() {
        AppService.shared.execute(.listCharacterRequests,
                                  expecting: GetAllCharacterResponse.self) { [weak self] result in
            switch result {
            case .success(let responseModel):
                guard let result = responseModel.results,
                      let info = responseModel.info else { return }
                self?.characters = result
                self?.apiInfo = info
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialCharacters()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    public func fetchAddicitionalCharacters() {
        // TODO - Fetch characters here
    }
    
    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
}

// MARK: - Delegate Methods

extension CharacterListViewViewModel: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellsViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCollectionViewCell.cellIdentifier,
                                                            for: indexPath) as? CharacterCollectionViewCell else { return UICollectionViewCell() }

        cell.configure(with: cellsViewModels[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width-30)/2
        
        return CGSize(width: width, height: width * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let character = characters[indexPath.row]
        delegate?.didSelectCharacter(character)
    }
}

// MARK: - ScrollView

extension CharacterListViewViewModel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator else { return }
        
        
    }
}
