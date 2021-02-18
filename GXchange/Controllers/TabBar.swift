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
                
        let firstVC = UINavigationController(rootViewController: HomeViewController())
        firstVC.tabBarItem.image = UIImage(systemName: "house")
        let secondVC = UINavigationController(rootViewController: FavouritesViewController())
        secondVC.tabBarItem.image = UIImage(systemName: "heart")
        secondVC.tabBarItem.title = "Favourites"
        
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            guard let self = self else {return}
            if user != nil {
                print("User is logged in")
                let thirdVC = UINavigationController(rootViewController: (LoggedInViewController()))
                thirdVC.tabBarItem.image = UIImage(systemName: "person")
                thirdVC.tabBarItem.title = "Profile"
                
                self.setViewControllers([firstVC, secondVC, thirdVC], animated: false)
            } else {
                print("User is NOT logged in")
                let thirdVC = UINavigationController(rootViewController: (ProfileViewController()))
                thirdVC.tabBarItem.image = UIImage(systemName: "person")
                thirdVC.tabBarItem.title = "Profile"
                
                self.setViewControllers([firstVC, secondVC, thirdVC], animated: false)
            }
        }
        
    }

}
