//
//  PSTableViewController.swift
//  GXchange
//
//  Created by Danabek Abildayev on 10/5/20.
//  Copyright © 2020 macbook. All rights reserved.
//

import UIKit
import Firebase

class PSTableViewController: UITableViewController {
    
    let db = Firestore.firestore()
    var psGames = [GameModel]()
    let logOut = UIButton(type: .custom)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "PS4 Games"
        
        tableView.register(UINib(nibName: "GameInfoCell", bundle: nil), forCellReuseIdentifier: "GameCell")
        
        setBarButtons()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadGames()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return psGames.count
    }
    
    //MARK: - Table view Delegate Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as! GameInfoCell
                
        cell.gName.text = psGames[indexPath.row].name
        cell.gPrice.text = psGames[indexPath.row].price
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "Game Info", message: "Testing", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            return
        }
        alert.addAction(action)
        present(alert, animated: true)
        
    }
    
    //MARK: - Firebase Firecloud Methods
    
    @objc func addPressed () {
        
        let destVC = AddGameTableViewController()
        navigationController?.present(destVC, animated: true)
        
    }
    
    
    func reloadGames() {
        
        db.collection("psGames").order(by: "game", descending: false).addSnapshotListener { (querySnapshot, err) in
            if let e = err {
                print("Error getting documents: \(e.localizedDescription)")
            } else {
                self.psGames = []
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let name = data["game"] as? String, let price = data["price"] as? String
                        {
                            let newGame = GameModel(name: name, price: price)
                            self.psGames.append(newGame)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    
    //MARK: - Log Out Pressed
    @objc func logOutPressed () {
                
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError.localizedDescription)
        }
    }
    
    
    //MARK: - Setting Bar Items
    
    func setBarButtons() {
        logOut.setTitle("LogOut", for: .normal)
        logOut.setTitleColor(.systemBlue, for: .normal)
        logOut.addTarget(self, action: #selector(logOutPressed), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: logOut)
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPressed))

        navigationItem.setRightBarButtonItems([addButton, item1], animated: true)
    }
    
    
}
