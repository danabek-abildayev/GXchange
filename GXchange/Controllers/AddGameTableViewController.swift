//
//  AddGameTableViewController.swift
//  GXchange
//
//  Created by Danabek Abildayev on 10/9/20.
//  Copyright © 2020 macbook. All rights reserved.
//

import UIKit
import Firebase

class AddGameTableViewController: UIViewController, UITextFieldDelegate {
    
    let db = Firestore.firestore()
    
    let name = UITextField()
    let price = UITextField()
    let image = UIImageView()
    let imageButton = UIButton()
    let city = UITextField()
    let contactName = UITextField()
    let contactNumber = UITextField()
    let contactAdress = UITextField()
    let addButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @objc func addGame () {
        
        if let name = name.text, let price = price.text, let city = city.text, let contName = contactName.text, let contNum = contactNumber.text, let contAddr = contactAdress.text {
            
            self.db.collection("psGames").addDocument(data: [
                "game" : name,
                "price" : price,
                "city" : city,
                "contact name" : contName,
                "contact number" : contNum,
                "contact address" : contAddr
            ])
            { err in
                if let e = err {
                    print("Error adding new game: \(e.localizedDescription)")
                } else {
                    print("Game added to store successfully!")
                    
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    
    
    
    func setItems() {
        
        view.backgroundColor = UIColor(red: 0.46, green: 0.47, blue: 0.91, alpha: 1.00)
        
        setTF(textField: name, placeholder: "Enter Game name")
        setTF(textField: price, placeholder: "Enter Game price", keyboardType: .numberPad)
        setTF(textField: city, placeholder: "Enter your city")
        setTF(textField: contactName, placeholder: "Enter your name")
        setTF(textField: contactNumber, placeholder: "Enter your number", keyboardType: .numberPad)
        setTF(textField: contactAdress, placeholder: "Enter your address")
        
        addButton.setTitle("Add Game", for: .normal)
        addButton.titleLabel?.font = .systemFont(ofSize: 17)
        addButton.backgroundColor = .systemOrange
        addButton.addTarget(self, action: #selector(addGame), for: .touchUpInside)
        
//        image.image = UIImage(named: "psn")
//
//        imageButton.setTitle("Add Image", for: .normal)
//        imageButton.titleLabel?.font = .systemFont(ofSize: 17)
//
//        let horizSV = UIStackView(arrangedSubviews: [image, imageButton])
//        horizSV.axis = .horizontal
//        horizSV.alignment = .center
//        horizSV.spacing = 20
//        horizSV.distribution = .equalSpacing
//        horizSV.translatesAutoresizingMaskIntoConstraints = false
        
        
        let firstSV = UIStackView(arrangedSubviews: [name, price, city, contactName, contactNumber, contactAdress, addButton])
        firstSV.axis = .vertical
        firstSV.alignment = .center
        firstSV.distribution = .equalSpacing
        firstSV.spacing = 20
        firstSV.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(firstSV)
        
        NSLayoutConstraint.activate([firstSV.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                     firstSV.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
                                     firstSV.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
                                     addButton.widthAnchor.constraint(equalToConstant: 120),
                                     addButton.heightAnchor.constraint(equalToConstant: 40),
                                     addButton.bottomAnchor.constraint(equalTo: firstSV.bottomAnchor),
                                     image.widthAnchor.constraint(equalToConstant: 60),
                                     image.heightAnchor.constraint(equalToConstant: 60),
                                     
        
        ])
    }
    
    func setTF (textField: UITextField, placeholder : String, keyboardType : UIKeyboardType? = nil) {
        
        textField.placeholder = placeholder
        textField.font = .systemFont(ofSize: 17)
        textField.borderStyle = .roundedRect
        textField.keyboardType = keyboardType ?? .default
        textField.autocorrectionType = .no
        textField.delegate = self
    }
    
}

