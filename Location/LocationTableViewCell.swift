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
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    private lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    private lazy var dimensionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .tertiaryLabel
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        addConstraints()
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        typeLabel.text = nil
        dimensionLabel.text = nil
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        let views = [nameLabel, typeLabel, dimensionLabel]
        contentView.addSubview(mainStackView)
        
        for view in views {
            mainStackView.addArrangedSubview(view)
        }
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 100),
            
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    func configure(with viewModel: LocationTableViewCellViewModel) {
        nameLabel.text = viewModel.name
        typeLabel.text = "Type: \(viewModel.type)"
        dimensionLabel.text = viewModel.dimension
    }
}
