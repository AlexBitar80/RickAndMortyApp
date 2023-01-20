//
//  CharacterViewController.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 07/01/23.
//

import UIKit

final class CharacterViewController: UIViewController {

    // MARK: - Properties
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Characters"
        view.backgroundColor = .systemBackground
        
//        let request = AppRequest(
//            endpoint: .character,
//            queryParameters: [
//                URLQueryItem(name: "name", value: "rick"),
//                URLQueryItem(name: "status", value: "alive")
//            ]
//        )
//
//        print(request.url)
//
//        AppService.shared.execute(request, expecting: Character.self) { result in
//            switch result {
//            case .success(let success):
//                print(success)
//            case .failure(let failure):
//
//            }
//        }
    }
    
    // MARK: - Helpers
    
    
}
