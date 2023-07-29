//
//  LocationTableViewCell.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 29/07/23.
//

import UIKit

class LocationTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "LocationTableViewCell"
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Helpers
    
    func configure(with viewModel: LocationTableViewCellViewModel) {}
}
