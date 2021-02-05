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

        
        register.setTitle("Register", for: .normal)
        register.titleLabel?.font = .systemFont(ofSize: 25)
        register.backgroundColor = .systemOrange
 //       register.center = CGPoint(x: view.bounds.midX, y: view.bounds.maxY - 180)
        register.addTarget(self, action: #selector(registerPressed), for: .touchUpInside)
        
        login.setTitle("Login", for: .normal)
        login.titleLabel?.font = .systemFont(ofSize: 25)
        login.backgroundColor = .systemOrange
 //       login.center = CGPoint(x: view.bounds.midX, y: view.bounds.maxY - 100)
        login.addTarget(self, action: #selector(loginPressed), for: .touchUpInside)
        
        let buttonSV = UIStackView(arrangedSubviews: [register, login])
        buttonSV.axis = .vertical
        buttonSV.alignment = .center
        buttonSV.distribution = .equalSpacing
        buttonSV.spacing = 20
        buttonSV.translatesAutoresizingMaskIntoConstraints = false
        
        psnImage.image = UIImage(named: "logo")
        psnImage.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        
        let stackView = UIStackView(arrangedSubviews: [gameLabel, psnImage, buttonSV])
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 50
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
                                     stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
                                     stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
                                     stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                     register.widthAnchor.constraint(equalToConstant: 110),
                                     register.heightAnchor.constraint(equalToConstant: 50),
                                     login.widthAnchor.constraint(equalToConstant: 80),
                                     login.heightAnchor.constraint(equalToConstant: 45)])

        
//        stackView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
//        stackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
//        stackView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
//        stackView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true

    }
    
}

