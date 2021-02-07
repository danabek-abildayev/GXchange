//
//  RegisterViewController.swift
//  GXchange
//
//  Created by Danabek Abildayev on 10/5/20.
//  Copyright © 2020 macbook. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    let emailField =  UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
    let passwordField =  UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
    let registerButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(red: 0.46, green: 0.47, blue: 0.91, alpha: 1.00)
                
        createTextFields()
        createButton()
    }

    
    
    @objc func registerPressed (_ sender: UIButton) {
        if let email = emailField.text, let password = passwordField.text {
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    let destinationVC = FavouritesViewController()
                    destinationVC.modalPresentationStyle = .fullScreen
                    self.navigationController?.pushViewController(destinationVC, animated: true)
                }
            }
            
        }
    }
    
    
    //MARK: - Creating TextField and Button
    
    func createTextFields() {
        emailField.placeholder = "Email"
        emailField.textAlignment = .center
        emailField.font = UIFont.systemFont(ofSize: 17)
        emailField.borderStyle = .none
        emailField.keyboardType = .default
        emailField.returnKeyType = .go
        emailField.autocapitalizationType = .none
        emailField.delegate = self
        emailField.center = CGPoint(x: view.bounds.midX, y: 200)
        emailField.background = UIImage(named: "capsule")
        self.view.addSubview(emailField)
        
        passwordField.placeholder = "Password"
        passwordField.textAlignment = .center
        passwordField.font = UIFont.systemFont(ofSize: 17)
        passwordField.borderStyle = .none
        passwordField.keyboardType = .default
        passwordField.returnKeyType = .go
        passwordField.isSecureTextEntry = true
        passwordField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        passwordField.delegate = self
        passwordField.center = CGPoint(x: view.bounds.midX, y: 270)
        passwordField.background = UIImage(named: "capsule")
        self.view.addSubview(passwordField)
    }
    
    func createButton() {
        registerButton.setTitle("Register", for: .normal)
        registerButton.titleLabel?.font = .systemFont(ofSize: 17)
        registerButton.backgroundColor = .systemOrange
        registerButton.center = CGPoint(x: view.bounds.midX, y: 370)
        registerButton.addTarget(self, action: #selector(registerPressed), for: .touchUpInside)
        self.view.addSubview(registerButton)
    }
}

