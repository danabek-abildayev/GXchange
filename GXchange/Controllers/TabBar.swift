//
//  HomeViewController.swift
//  GXchange
//
//  Created by Danabek Abildayev on 2/5/21.
//  Copyright © 2021 macbook. All rights reserved.
//

import UIKit

class TabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupVCs()
        
    }
    
    func setupVCs() {
        
        let firstVC = UINavigationController(rootViewController: FirstVC())
        firstVC.tabBarItem.image = UIImage(systemName: "house")
        let secondVC = UINavigationController(rootViewController: SecondVC())
        secondVC.tabBarItem.image = UIImage(systemName: "heart")
        let thirdVC = UINavigationController(rootViewController: ProfileViewController())
        thirdVC.tabBarItem.image = UIImage(systemName: "person")
        
        setViewControllers([firstVC, secondVC, thirdVC], animated: true)
    }

}


class FirstVC : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
    }
    
}

class SecondVC : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green
    }
    
}

class ThirdVC : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
    }
    
}

