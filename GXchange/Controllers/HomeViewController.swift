//
//  HomeViewController.swift
//  GXchange
//
//  Created by Danabek Abildayev on 2/5/21.
//  Copyright © 2021 macbook. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UISearchBarDelegate {
        
    let searchController = UISearchController(searchResultsController: nil)
    
    let defaults = UserDefaults.standard
    
    private var collectionView : UICollectionView!
    
    private let refreshControl = UIRefreshControl()
    
    let db = Firestore.firestore()
    private var psGames = [GameModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemTeal
        navigationController?.navigationBar.barTintColor = .systemTeal
        title = "GX-CHANGE"
        setNavBarItems()
        setSearchBar()
        setCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadGames()
    }
    
    private func setNavBarItems() {
        
        let image = UIImageView(image: UIImage(named: "logo"))
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([image.widthAnchor.constraint(equalToConstant: 35),
                                     image.heightAnchor.constraint(equalToConstant: 35)])
                
        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: image)]
        
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addGame))
        navigationItem.rightBarButtonItem = addItem
    }
    
    @objc private func addGame () {
        
        if Auth.auth().currentUser != nil {
            let destVC = AddGameViewController()
            navigationController?.pushViewController(destVC, animated: true)
        } else {
            let alert = UIAlertController(title: "Please Register or Login", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
            present(alert, animated: true)
        }
        
    }
    
    private func setSearchBar() {
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func reloadGames() {
        
        db.collection("psGames").order(by: "game", descending: false).addSnapshotListener { [weak self] (querySnapshot, err) in
            if let e = err {
                print("Error getting documents: \(e.localizedDescription)")
            } else {
                guard let self = self else { return }
                self.psGames = []
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let name = data["game"] as? String, let price = data["price"] as? String
                        {
                            let someBoolean = self.defaults.bool(forKey: name)
                            let newGame = GameModel(name: name, price: price, isFavourite: someBoolean)
                            self.psGames.append(newGame)
                            
                            DispatchQueue.main.async {
                                self.collectionView.reloadData()
                            }
                        }
                    }
                }
            }
        }
        
    }
    
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func setCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width: view.frame.width/2 - 10, height: view.frame.width/2)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(GameCell.self, forCellWithReuseIdentifier: GameCell.identifier)
        collectionView.backgroundColor = .clear
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshPage), for: .valueChanged)
        
        collectionView.frame = CGRect(x: 5, y: (navigationController?.navigationBar.frame.height)! + searchController.searchBar.frame.height + 35, width: view.frame.width - 10, height: view.frame.height - (navigationController?.navigationBar.frame.height)! - searchController.searchBar.frame.height - (tabBarController?.tabBar.frame.height)! - 35)
        view.addSubview(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return psGames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameCell.identifier, for: indexPath) as! GameCell
        
        cell.name.text = psGames[indexPath.row].name
        cell.price.text = psGames[indexPath.row].price
        
        cell.favouriteButton.tag = indexPath.row
        cell.favouriteButton.addTarget(self, action: #selector(heartPressed(sender:)), for: .touchUpInside)
        
        if psGames[indexPath.row].isFavourite {
            cell.favouriteButton.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
            defaults.setValue(true, forKey: cell.name.text!)
            print("\(cell.name.text!) is Favourite")
        } else {
            cell.favouriteButton.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
            defaults.setValue(false, forKey: cell.name.text!)
            print("\(cell.name.text!) is not favourite")
        }
        
        return cell
    }
    
    
    @objc private func heartPressed (sender: UIButton!) {
        
        psGames[sender.tag].isFavourite = !psGames[sender.tag].isFavourite
        
        collectionView.reloadData()
    }
    
    @objc private func refreshPage () {
        reloadGames()
        refreshControl.endRefreshing()
    }
    
    
    
}
