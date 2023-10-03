//
//  CharacterEpisodeCollectionViewCell.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 10/02/23.
//

import UIKit

final class CharacterEpisodeCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    
    static let cellIdetifier = "CharacterEpisodeCollectionViewCell"
    
    private lazy var seasonLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    private lazy var airDateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        setupConstraints()
        setupLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        seasonLabel.text = nil
        nameLabel.text = nil
        airDateLabel.text = nil
    }
    
    private func configureUI() {
        contentView.backgroundColor = .quaternarySystemFill
        contentView.addSubviews(seasonLabel, nameLabel, airDateLabel)
    }
    
    private func setupLayer() {
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 2
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            seasonLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            seasonLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            seasonLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            seasonLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.33),
            
            nameLabel.topAnchor.constraint(equalTo: seasonLabel.bottomAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            nameLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.33),
            
            airDateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            airDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            airDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            airDateLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.33)
        ])
    }
    
    public func configure(with viewModel: CharacterEpisodesCollectionViewCellViewModel) {
        viewModel.registerForData { [weak self] data in
            
            self?.seasonLabel.text = "Episode: \(data.episode)"
            self?.nameLabel.text = data.name
            self?.airDateLabel.text = "Aired on \(data.air_date)"
        }
        
        viewModel.fetchEpisode()
        
        contentView.layer.borderColor = viewModel.borderColor.cgColor
    }
}
