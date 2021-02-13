//
//  HomeViewController.swift
//  GXchange
//
//  Created by Danabek Abildayev on 2/5/21.
//  Copyright © 2021 macbook. All rights reserved.
//

import UIKit
import Firebase

class TabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupVCs()
        
    }
    
    func setupVCs() {
        
        let firstVC = UINavigationController(rootViewController: HomeViewController())
        firstVC.tabBarItem.image = UIImage(systemName: "house")
        let secondVC = UINavigationController(rootViewController: FavouritesViewController())
        secondVC.tabBarItem.image = UIImage(systemName: "heart")
        secondVC.tabBarItem.title = "Favourites"
        let thirdVC = UINavigationController(rootViewController: (userLoggedIn() ? LoggedInViewController() : ProfileViewController()))
        thirdVC.tabBarItem.image = UIImage(systemName: "person")
        thirdVC.tabBarItem.title = "Profile"
        
        setViewControllers([firstVC, secondVC, thirdVC], animated: true)
    }
    
    private func userLoggedIn() -> Bool {
        if Auth.auth().currentUser != nil {
            return true
        } else {
            return false
        }
    }

}
