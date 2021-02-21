//
//  SingleGameViewController.swift
//  GXchange
//
//  Created by Danabek Abildayev on 21.02.2021.
//  Copyright © 2021 macbook. All rights reserved.
//

import UIKit

class SingleGameViewController: UIViewController, UICollectionViewDelegate , UICollectionViewDataSource{
    
    var chosenGame : GameModel
    
    init(chosenGame : GameModel) {
        self.chosenGame = chosenGame
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let defaults = UserDefaults.standard
    
    private var collectionView : UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGreen
        
        print(chosenGame)
        
        setCollectionView()
        
        collectionView.delegate = self
        collectionView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    func setCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width: view.frame.width - 10, height: view.frame.width/2)
        
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let navBarHeight = (navigationController?.navigationBar.frame.height)!
        let tabBarHeight = (tabBarController?.tabBar.frame.height)!
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: navBarHeight + 5, width: view.bounds.width, height: view.bounds.height - navBarHeight - statusBarHeight - tabBarHeight - 5), collectionViewLayout: layout)
        collectionView.register(FavouriteGameCell.self, forCellWithReuseIdentifier: FavouriteGameCell.identifier)
        collectionView.backgroundColor = .clear
        
        view.addSubview(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavouriteGameCell.identifier, for: indexPath) as! FavouriteGameCell
        
        cell.name.text = chosenGame.name
        cell.price.text = "\(chosenGame.price) ₸"
        cell.city.text = "City: \(chosenGame.city!)"
        cell.phone.text = "Tel: \(chosenGame.phone!)"
        
        if let safeURL = chosenGame.gameImageURL {
            cell.putGameImage(from: safeURL)
//            print("\(cell.name.text!) 's URL is \(safeURL)")
        } else {
            cell.gameImage.image = UIImage(named: "psn")
        }
        
        if chosenGame.exchangeable {
            cell.checkboxImage.image = UIImage(named: "yes")
        } else {
            cell.checkboxImage.image = UIImage(named: "no")
        }
        
        cell.favouriteButton.tag = indexPath.row
        cell.favouriteButton.addTarget(self, action: #selector(heartPressed(sender:)), for: .touchUpInside)
        
        if chosenGame.isFavourite {
            cell.favouriteButton.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
            defaults.setValue(true, forKey: cell.name.text!)
        //    print("\(cell.name.text!) is Favourite")
        } else {
            cell.favouriteButton.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
            defaults.setValue(false, forKey: cell.name.text!)
        //    print("\(cell.name.text!) is not favourite")
        }
        
        return cell
    }
    
    @objc private func heartPressed (sender: UIButton!) {
        
        chosenGame.isFavourite = !chosenGame.isFavourite
        
        collectionView.reloadData()
    }
    

}
