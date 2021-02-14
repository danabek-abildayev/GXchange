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
    
    private var filteredGamesArray : [GameModel] = []
    
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
                        if let name = data["game"] as? String, let price = data["price"] as? String, let exchangeable = data["exchangeable"] as? Bool
                        {
                            let someBoolean = self.defaults.bool(forKey: name)
                            let newGame = GameModel(name: name, price: price, isFavourite: someBoolean, gameImageURL: data["imageURL"] as? String, exchangeable: exchangeable)
                            self.psGames.append(newGame)
                            
                            DispatchQueue.main.async {
                                self.filteredGamesArray = self.psGames
                                self.collectionView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - Search Bar methods
        
    private func setSearchBar() {
        searchController.searchBar.delegate = self
        searchController.searchBar.returnKeyType = .done
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            filteredGamesArray = psGames
            view.endEditing(true)
            collectionView.reloadData()
        } else {
            filteredGamesArray = []
            
            for gameModel in psGames {
                if gameModel.name.lowercased().contains(searchText.lowercased()) {
                    filteredGamesArray.append(gameModel)
                }
            }
            collectionView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredGamesArray = psGames
        collectionView.reloadData()
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
        
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let navBarHeight = (navigationController?.navigationBar.frame.height)!
        let tabBarHeight = (tabBarController?.tabBar.frame.height)!
        
        collectionView.frame = CGRect(x: 5, y: navBarHeight + searchController.searchBar.frame.height + statusBarHeight, width: view.frame.width - 10, height: view.frame.height - navBarHeight - searchController.searchBar.frame.height - tabBarHeight - statusBarHeight)
        view.addSubview(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredGamesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameCell.identifier, for: indexPath) as! GameCell
        
        cell.name.text = filteredGamesArray[indexPath.row].name
        cell.price.text = "\(filteredGamesArray[indexPath.row].price) ₸"
        
        if let safeURL = filteredGamesArray[indexPath.row].gameImageURL {
            cell.putGameImage(from: safeURL)
//            print("\(cell.name.text!) 's URL is \(safeURL)")
        } else {
            cell.gameImage.image = UIImage(named: "psn")
        }
        
        if filteredGamesArray[indexPath.row].exchangeable {
            cell.checkboxImage.image = UIImage(named: "yes")
        } else {
            cell.checkboxImage.image = UIImage(named: "no")
        }
        
        cell.favouriteButton.tag = indexPath.row
        cell.favouriteButton.addTarget(self, action: #selector(heartPressed(sender:)), for: .touchUpInside)
        
        if filteredGamesArray[indexPath.row].isFavourite {
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
        
        filteredGamesArray[sender.tag].isFavourite = !filteredGamesArray[sender.tag].isFavourite
        
        collectionView.reloadData()
    }
    
    @objc private func refreshPage () {
        reloadGames()
        refreshControl.endRefreshing()
    }
    
    
    
}
