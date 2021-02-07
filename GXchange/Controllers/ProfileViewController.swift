//
//  ViewController.swift
//  GXchange
//
//  Created by Danabek Abildayev on 10/5/20.
//  Copyright © 2020 macbook. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let gameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
    let register = UIButton(frame: CGRect(x: 0, y: 0, width: 110, height: 50))
    let login = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 45))
    let psnImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 0.46, green: 0.47, blue: 0.91, alpha: 1.00)
        setupLabel()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc func registerPressed () {
        
        let destinationVC = RegisterViewController()
        destinationVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    @objc func loginPressed () {
        
        let destinationVC = LoginViewController()
        destinationVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func setupLabel() {
        
        gameLabel.text = "GX-CHANGE"
        gameLabel.textColor = .white
        gameLabel.font = .systemFont(ofSize: 50)
        gameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gameLabel)
        
        register.setTitle("Register", for: .normal)
        register.titleLabel?.font = .systemFont(ofSize: 25)
        register.backgroundColor = .systemOrange
        register.layer.cornerRadius = 20
        register.addTarget(self, action: #selector(registerPressed), for: .touchUpInside)
        register.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(register)
        
        login.setTitle("Login", for: .normal)
        login.titleLabel?.font = .systemFont(ofSize: 25)
        login.backgroundColor = .systemOrange
        login.layer.cornerRadius = 20
        login.addTarget(self, action: #selector(loginPressed), for: .touchUpInside)
        login.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(login)
                
        psnImage.image = UIImage(named: "logo")
        psnImage.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        psnImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(psnImage)
        
        NSLayoutConstraint.activate([
                                        gameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                        gameLabel.centerYAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height/4),
                                        psnImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                        psnImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                        register.topAnchor.constraint(equalTo: psnImage.bottomAnchor, constant: view.frame.height/16),
                                        register.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                        register.widthAnchor.constraint(equalToConstant: 110),
                                        register.heightAnchor.constraint(equalToConstant: 50),
                                        login.topAnchor.constraint(equalTo: register.bottomAnchor, constant: view.frame.height/32),
                                        login.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                        login.widthAnchor.constraint(equalToConstant: 80),
                                        login.heightAnchor.constraint(equalToConstant: 45)])
        
    }
    
}

