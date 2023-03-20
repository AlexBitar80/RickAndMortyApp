//
//  SearchViewController.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 07/03/23.
//

import UIKit

final class SearchViewController: UIViewController {

    // MARK: - Properties
    
    struct Config {
        enum `Type` {
            case character
            case location
            case episode
        }
        
        let type: `Type`
    }
    
    private let config: Config
    
    // MARK: - Init
    
    init(config: Config) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        title = "Search"
    }

    // MARK: - Helpers

}
