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
}

final class CharacterListViewViewModel: NSObject {
    
    // MARK: - Properties
    
    public weak var delegate: CharacterListViewViewModelDelegate?
    
    private var characters: [MRCharacter] = [] {
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
    
    public func fetchCharacters() {
        AppService.shared.execute(.listCharacterRequests,
                                  expecting: GetAllCharacterResponse.self) { [weak self] result in
            switch result {
            case .success(let responseModel):
                guard let result = responseModel.results else { return }
                self?.characters = result
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialCharacters()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}

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
}
