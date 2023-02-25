//
//  EpisodeDetailViewController.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 14/02/23.
//

import UIKit

final class EpisodeDetailViewController: UIViewController {

    // MARK: Properties
    
    private let viewModel: EpisodeDetailViewViewModel?
    
    // MARK: - Init
    
    init(url: URL?) {
        self.viewModel = .init(endpointUrl: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Episode"
        view.backgroundColor = .systemBackground
    }
}
