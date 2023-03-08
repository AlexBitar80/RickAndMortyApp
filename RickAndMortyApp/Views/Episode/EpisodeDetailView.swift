//
//  EpisodeDetailView.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 24/02/23.
//

import UIKit

final class EpisodeDetailView: UIView {
    
    // MARK: - Properties
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
