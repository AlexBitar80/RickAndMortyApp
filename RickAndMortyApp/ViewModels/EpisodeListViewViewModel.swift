//
//  EpisodeListViewViewModel.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 02/03/23.
//

import Foundation
import UIKit

protocol EpisodeListViewViewModelDelegate: AnyObject {
    func didLoadInitialEpisodes()
    func didLoadMoreEpisodes(with newIndexPaths: [IndexPath])
    func didSelectEpisode(_ episode: Episode)
}

final class EpisodeListViewViewModel: NSObject {
    
    // MARK: - Properties
    
    public weak var delegate: EpisodeListViewViewModelDelegate?
    
    private var isLoadingMoreCharactes: Bool = false
    
    private let borderColors: [UIColor] = [
        .systemBlue,
        .systemOrange,
        .systemRed,
        .systemTeal,
        .systemCyan,
        .systemGray,
        .systemMint,
        .systemPink,
        .systemBrown,
        .systemGreen,
        .systemYellow,
        .systemIndigo,
        .systemPurple,
    ]
    
    private var episodes: [Episode] = [] {
        didSet {
            for episode in episodes {
                let viewModel = CharacterEpisodesCollectionViewCellViewModel(episodeDataUrl: URL(string: episode.url),
                                                                             borderColor: borderColors.randomElement() ?? .systemBlue)
                if !cellsViewModels.contains(viewModel) {
                    cellsViewModels.append(viewModel)
                }
            }
        }
    }
    
    
    
    private var cellsViewModels: [CharacterEpisodesCollectionViewCellViewModel] = []
    
    private var apiInfo: GetAllEpisodesResponseInfo? = nil
    
    public func fetchEpisodes() {
        AppService.shared.execute(
            .listEpisodesRequest,
            expecting: GetAllEpisodesResponse.self
        ) { [weak self] result in
            switch result {
            case .success(let responseModel):
                let results = responseModel.results
                let info = responseModel.info
                self?.episodes = results
                self?.apiInfo = info
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialEpisodes()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    public func fetchAdditionalEpisodes(url: URL) {
        guard !isLoadingMoreCharactes else {
            return
        }
        isLoadingMoreCharactes = true
        guard let request = AppRequest(url: url) else {
            isLoadingMoreCharactes = false
            return
        }
        
        AppService.shared.execute(request, expecting: GetAllEpisodesResponse.self) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel.results
                let info = responseModel.info
                strongSelf.apiInfo = info
                
                let originalCount = strongSelf.episodes.count
                let newCount = moreResults.count
                let total = originalCount+newCount
                let startingIndex = total - newCount
                let indexPathsToAdd: [IndexPath] = Array(startingIndex..<(startingIndex+newCount)).compactMap({
                    return IndexPath(row: $0, section: 0)
                })
                strongSelf.episodes.append(contentsOf: moreResults)
                
                DispatchQueue.main.async {
                    strongSelf.delegate?.didLoadMoreEpisodes(
                        with: indexPathsToAdd
                    )
                    
                    strongSelf.isLoadingMoreCharactes = false
                }
            case .failure(let failure):
                print(String(describing: failure))
                self?.isLoadingMoreCharactes = false
            }
        }
    }
    
    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
}

// MARK: - Delegate Methods

extension EpisodeListViewViewModel: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellsViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterEpisodeCollectionViewCell.cellIdetifier,
                                                            for: indexPath) as? CharacterEpisodeCollectionViewCell else { return UICollectionViewCell() }
        
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
        let bounds = collectionView.bounds
        let width = bounds.width-20
        
        return CGSize(width: width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let selection = episodes[indexPath.row]
        delegate?.didSelectEpisode(selection)
    }
}

// MARK: - ScrollView

extension EpisodeListViewViewModel: UIScrollViewDelegate {
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
                self?.fetchAdditionalEpisodes(url: url)
            }
            
            t.invalidate()
        }
    }
}
