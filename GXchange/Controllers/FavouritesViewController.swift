//
//  PSTableViewController.swift
//  GXchange
//
//  Created by Danabek Abildayev on 10/5/20.
//  Copyright © 2020 macbook. All rights reserved.
//

import UIKit
import Firebase

class FavouritesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let db = Firestore.firestore()
    private var favouriteGames = [GameModel]()
    
    private var cv: UICollectionView!
    
    let defaults = UserDefaults.standard
    
    private let refreshControl = UIRefreshControl()
            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Favourites"
        setCollectionView()
        
        cv.dataSource = self
        cv.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadGames()
    }
    
    private func setCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width: view.frame.width - 10, height: view.frame.width/2)
        
        cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height), collectionViewLayout: layout)
        cv.register(FavouriteGameCell.self, forCellWithReuseIdentifier: FavouriteGameCell.identifier)
        cv.backgroundColor = .green
        cv.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshPage), for: .valueChanged)
        
        view.addSubview(cv)
    }
    
    @objc private func refreshPage() {
        reloadGames()
        refreshControl.endRefreshing()
    }
    
    private func reloadGames() {
        
        db.collection("psGames").order(by: "game", descending: false).addSnapshotListener { [weak self] (querySnapshot, err) in
            if let e = err {
                print("Error getting documents: \(e.localizedDescription)")
            } else {
                guard let self = self else {return}
                self.favouriteGames = []
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let name = data["game"] as? String, let price = data["price"] as? String, let city = data["city"] as? String, let phone = data["phone"] as? String
                        {
                            let isFavourite = self.defaults.bool(forKey: name)
                            print("\(name) is indicated as \(isFavourite)")
                            if isFavourite {
                                let newGame = GameModel(name: name, price: price, isFavourite: isFavourite, city: city, phone: phone)
                                self.favouriteGames.append(newGame)
                            }
                            DispatchQueue.main.async {
                                self.cv.reloadData()
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favouriteGames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavouriteGameCell.identifier, for: indexPath) as! FavouriteGameCell
        
        cell.name.text = favouriteGames[indexPath.row].name
        cell.price.text = "\(favouriteGames[indexPath.row].price) ₸"
        cell.city.text = "City: \(favouriteGames[indexPath.row].city!)"
        cell.phone.text = "Tel: \(favouriteGames[indexPath.row].phone!)"
        
        cell.favouriteButton.tag = indexPath.row
        cell.favouriteButton.addTarget(self, action: #selector(heartPressed(sender:)), for: .touchUpInside)
        
        if favouriteGames[indexPath.row].isFavourite {
            cell.favouriteButton.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
            defaults.setValue(true, forKey: cell.name.text!)
        } else {
            cell.favouriteButton.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
            defaults.setValue(false, forKey: cell.name.text!)
        }
        
        return cell
    }
    
    @objc private func heartPressed (sender: UIButton!) {
        
        favouriteGames[sender.tag].isFavourite = !favouriteGames[sender.tag].isFavourite
        
        cv.reloadData()
    }
    
}
