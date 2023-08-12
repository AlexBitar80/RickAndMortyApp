//
//  LocationDetailViewController.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 30/07/23.
//

import UIKit

class LocationDetailViewController: UIViewController {

    // MARK: - Properties
    
    let location: Location
    
    // MARK: - Init
    
    init(location: Location) {
        self.location = location
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = location.name
        view.backgroundColor = .systemBackground
    }
    
    // MARK: - Helpers
    
}
