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
    
    private var filteredArray : [GameModel] = []
    
    private var isSearching: Bool = false
    private var showOnlyExchangeables : Bool? = nil
    
    private var doubleFilteredArray : [GameModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemTeal
        navigationController?.navigationBar.barTintColor = .systemTeal
        title = "GX-CHANGE"
        setNavBarItems()
        setSearchBar()
        setCollectionView()
        reloadGames()
    }
    
    private func setNavBarItems() {
        
        let image = UIImageView(image: UIImage(named: "logo"))
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([image.widthAnchor.constraint(equalToConstant: 35),
                                     image.heightAnchor.constraint(equalToConstant: 35)])
                
        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: image)]
        
        let filterButton = UIBarButtonItem.init(title: "Filter", style: .plain, target: self, action: #selector(filterTapped))
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addGame))
        navigationItem.rightBarButtonItems = [addItem, filterButton]
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
    
    @objc func filterTapped () {
        
        let alertVC = UIAlertController(title: "Please choose", message: "Do you want to see only exchangeable games?", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Only exchangeable games", style: .default, handler: { [weak self] (action) in
            guard let self = self else {return}
            self.showOnlyExchangeables = true
            self.collectionView.reloadData()
        }))
        alertVC.addAction(UIAlertAction(title: "Only non-exchangeable games", style: .default, handler: { [weak self] (action) in
            guard let self = self else {return}
            self.showOnlyExchangeables = false
            self.collectionView.reloadData()
        }))
        alertVC.addAction(UIAlertAction(title: "Reset", style: .cancel, handler: { [weak self] (action) in
            guard let self = self else {return}
            self.filteredArray = self.psGames
            self.showOnlyExchangeables = nil
            self.collectionView.reloadData()
        }))
        present(alertVC, animated: true)
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
                        if let name = data["game"] as? String, let price = data["price"] as? String, let city = data["city"] as? String, let phone = data["phone"] as? String, let exchangeable = data["exchangeable"] as? Bool
                        {
                            let someBoolean = self.defaults.bool(forKey: name)
                            let newGame = GameModel(name: name, price: price, isFavourite: someBoolean, city: city, phone: phone, gameImageURL: data["imageURL"] as? String, exchangeable: exchangeable)
                            self.psGames.append(newGame)
                            
                            DispatchQueue.main.async {
                                self.filteredArray = self.psGames
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
            isSearching = false
            filteredArray = psGames
            view.endEditing(true)
            collectionView.reloadData()
        } else {
            isSearching = true
            filteredArray = []
            
            for gameModel in psGames {
                if gameModel.name.lowercased().contains(searchText.lowercased()) {
                    filteredArray.append(gameModel)
                }
            }
            collectionView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        filteredArray = psGames
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
        
        if showOnlyExchangeables != nil {
            if isSearching {
                doubleFilteredArray = []
                for gameModel in filteredArray {
                    if gameModel.exchangeable == showOnlyExchangeables {
                        doubleFilteredArray.append(gameModel)
                    }
                }
                return doubleFilteredArray.count
            } else {
                filteredArray = []
                for gameModel in psGames {
                    if gameModel.exchangeable == showOnlyExchangeables {
                        filteredArray.append(gameModel)
                    }
                }
                return filteredArray.count
            }
        } else {
            return filteredArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameCell.identifier, for: indexPath) as! GameCell
        
        if showOnlyExchangeables != nil {
            if isSearching {
                doubleFilteredArray = []
                for gameModel in filteredArray {
                    if gameModel.exchangeable == showOnlyExchangeables {
                        doubleFilteredArray.append(gameModel)
                    }
                }
            } else {
                filteredArray = []
                for gameModel in psGames {
                    if gameModel.exchangeable == showOnlyExchangeables {
                        filteredArray.append(gameModel)
                    }
                }
            }
        }
        
        if isSearching && showOnlyExchangeables != nil {
            
            cell.name.text = doubleFilteredArray[indexPath.row].name
            cell.price.text = "\(doubleFilteredArray[indexPath.row].price) ₸"
            
            if let safeURL = doubleFilteredArray[indexPath.row].gameImageURL {
                cell.putGameImage(from: safeURL)
    //            print("\(cell.name.text!) 's URL is \(safeURL)")
            }
            
            if doubleFilteredArray[indexPath.row].exchangeable {
                cell.checkboxImage.image = UIImage(named: "yes")
            } else {
                cell.checkboxImage.image = UIImage(named: "no")
            }
            
        } else {
            
            cell.name.text = filteredArray[indexPath.row].name
            cell.price.text = "\(filteredArray[indexPath.row].price) ₸"
            
            if let safeURL = filteredArray[indexPath.row].gameImageURL {
                cell.putGameImage(from: safeURL)
    //            print("\(cell.name.text!) 's URL is \(safeURL)")
            }
            
            if filteredArray[indexPath.row].exchangeable {
                cell.checkboxImage.image = UIImage(named: "yes")
            } else {
                cell.checkboxImage.image = UIImage(named: "no")
            }
            
        }
                
        return cell
    }
    
    @objc private func refreshPage () {
        reloadGames()
        refreshControl.endRefreshing()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isSearching && showOnlyExchangeables != nil {
            let destVC = SingleGameViewController(chosenGame: doubleFilteredArray[indexPath.row])
            navigationController?.pushViewController(destVC, animated: true)
        } else {
            let destVC = SingleGameViewController(chosenGame: filteredArray[indexPath.row])
            navigationController?.pushViewController(destVC, animated: true)
        }
    }
    
}
