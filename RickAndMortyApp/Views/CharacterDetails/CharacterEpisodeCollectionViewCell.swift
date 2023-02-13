//
//  CharacterEpisodeCollectionViewCell.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 10/02/23.
//

import UIKit

final class CharacterEpisodeCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    
    static let cellIndetifier = "CharacterEpisodeCollectionViewCell"
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    public func configure(with viewModel: CharacterEpisodesCollectionViewCellViewModel) {
        
    }
    
    private func setupConstraints() {
        
    }
}
