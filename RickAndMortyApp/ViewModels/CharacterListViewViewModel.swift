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
    func didLoadMoreCharacters(with newIndexPaths: [IndexPath])
    func didSelectCharacter(_ character: RMCharacter)
}

final class CharacterListViewViewModel: NSObject {
    
    // MARK: - Properties
    
    public weak var delegate: CharacterListViewViewModelDelegate?
    
    private var isLoadingMoreCharactes: Bool = false
    
    private var characters: [RMCharacter] = [] {
        didSet {
            for character in characters {
                guard let name = character.name,
                      let status = character.status,
                      let image = character.image else { return }
                
                let viewModel = CharacterCollectionViewCelltViewViewModel(characterName: name,
                                                                          characterStatus: status,
                                                                          characterImageUrl: URL(string: image))
                if !cellsViewModels.contains(viewModel) {
                    cellsViewModels.append(viewModel)
                }
            }
        }
    }
    
    private var cellsViewModels: [CharacterCollectionViewCelltViewViewModel] = []
    
    private var apiInfo: GetAllCharacterResponseInfo? = nil
    
    public func fetchCharacters() {
        AppService.shared.execute(.listCharactersRequests,
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
    
    public func fetchAddicitionalCharacters(url: URL) {
        guard !isLoadingMoreCharactes else { return }
        
        isLoadingMoreCharactes = true
        guard let request = AppRequest(url: url) else {
            isLoadingMoreCharactes = false
            return
        }
        
        AppService.shared.execute(request, expecting: GetAllCharacterResponse.self) { [weak self] resuslt in
            guard let strongSelf = self else { return }
            switch resuslt {
            case .success(let responseModel):
                guard let moreResults = responseModel.results,
                      let info = responseModel.info else { return }
                
                let originalCount = strongSelf.characters.count
                let newCount = moreResults.count
                let total = originalCount+newCount
                let startingIndex = total - newCount
                let indexPathsToAdd: [IndexPath] = Array(startingIndex..<(startingIndex+newCount)).compactMap({
                    return IndexPath(row: $0, section: 0)
                })
                
                strongSelf.characters.append(contentsOf: moreResults)
                strongSelf.apiInfo = info
                DispatchQueue.main.async {
                    strongSelf.delegate?.didLoadMoreCharacters(with: indexPathsToAdd)
                }
                
                strongSelf.isLoadingMoreCharactes = false
            case .failure:
                strongSelf.isLoadingMoreCharactes = false
            }
        }
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
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionFooter else {
            fatalError("Unsupported")
        }
        
        guard let footer = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "FooterLoadingCollectionReusableView",
            for: indexPath) as? FooterLoadingCollectionReusableView
        else {
            fatalError("Unsupported")
        }
        footer.startAnimating()
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        
        guard shouldShowLoadMoreIndicator else {
            return .zero
        }
        
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
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
        guard shouldShowLoadMoreIndicator,
              !isLoadingMoreCharactes,
              !cellsViewModels.isEmpty,
              let nextUrlString = apiInfo?.next,
              let url = URL(string: nextUrlString) else { return }
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollVieFixedHeight = scrollView.frame.size.height
            
            if offset >= (totalContentHeight - totalScrollVieFixedHeight - 120) {
                self?.fetchAddicitionalCharacters(url: url)
            }
            
            t.invalidate()
        }
    }
}
