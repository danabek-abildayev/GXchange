//
//  AddGameTableViewController.swift
//  GXchange
//
//  Created by Danabek Abildayev on 10/9/20.
//  Copyright © 2020 macbook. All rights reserved.
//

import UIKit
import Firebase

class AddGameViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let db = Firestore.firestore()
    
    private var name = UITextField()
    private var price = UITextField()
    private var image : UIImage! {
        didSet {
            imageButton.setImage(image, for: .normal)
            imageData = image.pngData()
        }
    }
    private var imageData : Data!
    private var exchange : Bool!
    private var checkmark = UIButton()
    private var city = UITextField()
    private var phone = UITextField()
    private var imageButton = UIButton()
    private var addButton = UIButton()
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setItems()
        imagePicker.delegate = self
    }
    
    @objc func addGame () {
        
        print("Add button pressed")
        
        if name.text != "", price.text != "", city.text != "", phone.text != "" {
            
            self.db.collection("psGames").addDocument(data: [
                "game" : name.text!,
                "price" : price.text!,
                "city" : city.text!,
                "phone" : phone.text!,
            ])
            { [weak self] err in
                guard let self = self else {return}
                if let e = err {
                    print("Error adding new game: \(e.localizedDescription)")
                } else {
                    print("Game added to store successfully!")
                    
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } else {
            let alert = UIAlertController(title: "Please try again", message: "Please enter valid information", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Try again", style: .default))
            present(alert, animated: true)
        }
    }
    
    @objc func addImage() {
        
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func setItems() {
        
        view.backgroundColor = UIColor(red: 0.46, green: 0.47, blue: 0.91, alpha: 1.00)
        
        setTF(textField: name, placeholder: "Enter Game name")
        setTF(textField: price, placeholder: "Enter Game price", keyboardType: .numberPad)
        setTF(textField: city, placeholder: "Enter your city")
        setTF(textField: phone, placeholder: "Enter your phone", keyboardType: .numberPad)
        
        imageButton.setTitle("Add Image", for: .normal)
        imageButton.titleLabel?.font = .systemFont(ofSize: 17)
        imageButton.titleLabel?.textAlignment = .center
        imageButton.layer.cornerRadius = 0.5 * 150
        imageButton.layer.borderWidth = 1
        imageButton.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        imageButton.addTarget(self, action: #selector(addImage), for: .touchUpInside)
        imageButton.clipsToBounds = true
        
        addButton.setTitle("Add Game", for: .normal)
        addButton.titleLabel?.font = .systemFont(ofSize: 17)
        addButton.backgroundColor = .systemOrange
        addButton.addTarget(self, action: #selector(addGame), for: .touchUpInside)
        
        
        //
        //        let horizSV = UIStackView(arrangedSubviews: [image, imageButton])
        //        horizSV.axis = .horizontal
        //        horizSV.alignment = .center
        //        horizSV.spacing = 20
        //        horizSV.distribution = .equalSpacing
        //        horizSV.translatesAutoresizingMaskIntoConstraints = false
        
        
        let firstSV = UIStackView(arrangedSubviews: [imageButton, name, price, city, phone, addButton])
        firstSV.axis = .vertical
        firstSV.alignment = .center
        firstSV.distribution = .equalSpacing
        firstSV.spacing = 20
        firstSV.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(firstSV)
        
        NSLayoutConstraint.activate([firstSV.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                     firstSV.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
                                     firstSV.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
                                     imageButton.widthAnchor.constraint(equalToConstant: 150),
                                     imageButton.heightAnchor.constraint(equalToConstant: 150),
                                     addButton.widthAnchor.constraint(equalToConstant: 120),
                                     addButton.heightAnchor.constraint(equalToConstant: 40),
                                     
                                     
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

