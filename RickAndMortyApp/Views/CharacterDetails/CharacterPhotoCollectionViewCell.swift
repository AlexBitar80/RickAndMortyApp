//
//  CharacterPhotoCollectionViewCell.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 10/02/23.
//

import UIKit

final class CharacterPhotoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let cellIndetifier = "CharacterPhotoCollectionViewCell"
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    private func configureUI() {
        contentView.addSubview(imageView)
    }
    
    public func configure(with viewModel: CharacterPhotoCollectionViewCellViewModel) {
        viewModel.fetchImage { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data)
                }
            case .failure:
               break
            }
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
