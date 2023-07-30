//
//  LocartionViewController.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 07/01/23.
//

import UIKit

final class LocationViewController: UIViewController {

    // MARK: - Properties
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Locations"
        view.backgroundColor = .systemBackground
        addSearchButton()
    }
    
    // MARK: - Helpers
    
    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                                            target: self,
                                                            action: #selector(didTapSearch))
    }
    
    @objc private func didTapSearch() {
        
    }
}
