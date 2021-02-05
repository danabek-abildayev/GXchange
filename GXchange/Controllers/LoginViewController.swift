//
//  LoginViewController.swift
//  GXchange
//
//  Created by Danabek Abildayev on 10/5/20.
//  Copyright © 2020 macbook. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    let login =  UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
    let password =  UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
    let loginButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(red: 0.46, green: 0.47, blue: 0.91, alpha: 1.00)
        
        createItems()
        
    }
    
    @objc func loginPressed (_ sender: UIButton) {
        if let email = login.text, let password = password.text {
            
            Auth.auth().signIn(withEmail: email, password: password) {authResult, error in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    DispatchQueue.main.async {
                        let destinationVC = PlatformChooseViewController()
                        destinationVC.modalPresentationStyle = .fullScreen
                        self.navigationController?.pushViewController(destinationVC, animated: true)
                    }
                    
                }
            }
            
        }
    }
    
    //MARK: - Creating TextField and Button
    
    func createItems() {
        login.placeholder = "Email"
        login.text = "test@mail.ru"
        login.textAlignment = .center
        login.textColor = .black
        login.font = UIFont.systemFont(ofSize: 17)
        login.borderStyle = .none
        login.keyboardType = .default
        login.returnKeyType = .go
        login.autocapitalizationType = .none
        login.delegate = self
 //       login.center = CGPoint(x: view.bounds.midX, y: 200)
        login.background = UIImage(named: "capsule")
        self.view.addSubview(login)
        
        password.placeholder = "Password"
        password.text = "123456"
        password.textAlignment = .center
        password.textColor = .black
        password.font = UIFont.systemFont(ofSize: 17)
        password.borderStyle = .none
        password.keyboardType = .default
        password.returnKeyType = .go
        password.isSecureTextEntry = true
        password.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        password.delegate = self
  //      password.center = CGPoint(x: view.bounds.midX, y: 270)
        password.background = UIImage(named: "capsule")
        self.view.addSubview(password)
        
        loginButton.setTitle("Login", for: .normal)
        loginButton.titleLabel?.font = .systemFont(ofSize: 17)
        loginButton.backgroundColor = .systemOrange
  //      loginButton.center = CGPoint(x: view.bounds.midX, y: 370)
        loginButton.addTarget(self, action: #selector(loginPressed), for: .touchUpInside)
        self.view.addSubview(loginButton)
        
        let SV = UIStackView(arrangedSubviews: [login, password, loginButton])
        SV.translatesAutoresizingMaskIntoConstraints = false
        SV.axis = .vertical
        SV.alignment = .center
        SV.distribution = .equalSpacing
        SV.spacing = 30
        view.addSubview(SV)
        
        NSLayoutConstraint.activate([SV.centerXAnchor.constraint(equalTo: view.centerXAnchor), SV.centerYAnchor.constraint(equalTo: view.centerYAnchor), login.widthAnchor.constraint(equalToConstant: 200), login.heightAnchor.constraint(equalToConstant: 40), password.widthAnchor.constraint(equalToConstant: 200), password.heightAnchor.constraint(equalToConstant: 40), loginButton.widthAnchor.constraint(equalToConstant: 100), loginButton.heightAnchor.constraint(equalToConstant: 40)])
    }
        
}
