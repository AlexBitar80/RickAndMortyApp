//
//  EpisodeInfoCollectionViewCell.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 10/03/23.
//

import UIKit

final class EpisodeInfoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let cellIdentifier = "EpisodeInfoCollectionViewCell"
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemBackground
        setUpLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Helpers
    
    private func setUpLayer() {
        layer.cornerRadius = 8
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.secondaryLabel.cgColor
    }
    
    func configure(with viewModel: EpisodeInfoCollectionViewCellViewModel) {
        
    }
}
