//
//  ViewController.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 06/01/23.
//

import UIKit

final class MainTabViewController: UITabBarController {

    // MARK: - Properties
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        setupTabs()
    }
    
    // MARK: - Helpers
    
    private func setupTabs() {
        let characters = CharacterViewController()
        let location = LocationViewController()
        let episodes = EpisodesViewController()
        let settings = SettingsViewController()
        
        characters.navigationItem.largeTitleDisplayMode = .automatic
        location.navigationItem.largeTitleDisplayMode = .automatic
        episodes.navigationItem.largeTitleDisplayMode = .automatic
        settings.navigationItem.largeTitleDisplayMode = .automatic
    
        let nav1 = UINavigationController(rootViewController: characters)
        let nav2 = UINavigationController(rootViewController: location)
        let nav3 = UINavigationController(rootViewController: episodes)
        let nav4 = UINavigationController(rootViewController: settings)
        
        nav1.tabBarItem = UITabBarItem(title: "Characters",
                                       image: UIImage(systemName: "person.circle"),
                                       tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Locations",
                                       image: UIImage(systemName: "globe"),
                                       tag: 2)
        nav3.tabBarItem = UITabBarItem(title: "Episodes",
                                       image: UIImage(systemName: "tv"),
                                       tag: 3)
        nav4.tabBarItem = UITabBarItem(title: "Settings",
                                       image: UIImage(systemName: "gear"),
                                       tag: 4)
        
        [nav1, nav2, nav3, nav4].forEach { nav in
            nav.navigationBar.prefersLargeTitles = true
        }
        
        setViewControllers(
            [nav1, nav2, nav3, nav4],
            animated: true
        )
    }
}
