//
//  PlatformChooseViewController.swift
//  GXchange
//
//  Created by Danabek Abildayev on 10/5/20.
//  Copyright © 2020 macbook. All rights reserved.
//

import UIKit

class PlatformChooseViewController: UIViewController {
    
    let PS = UIButton(frame: CGRect(x: 0, y: 0, width: 270, height: 70))
    let XBox = UIButton(frame: CGRect(x: 0, y: 0, width: 140, height: 60))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(red: 0.46, green: 0.47, blue: 0.91, alpha: 1.00)
        
        setupButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    @objc func PSPressed () {
        let destinationVC = PSTableViewController()
        destinationVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    @objc func XBoxPressed () {
        let destinationVC = XBoxTableViewController()
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    
    func setupButtons() {
        
        PS.setTitle("Play Station", for: .normal)
        PS.titleLabel?.font = .systemFont(ofSize: 50)
        PS.backgroundColor = .systemOrange
        PS.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY - 150)
        PS.addTarget(self, action: #selector(PSPressed), for: .touchUpInside)
        self.view.addSubview(PS)
        
        XBox.setTitle("XBox", for: .normal)
        XBox.titleLabel?.font = .systemFont(ofSize: 50)
        XBox.backgroundColor = .systemOrange
        XBox.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY + 150)
        XBox.addTarget(self, action: #selector(XBoxPressed), for: .touchUpInside)
        self.view.addSubview(XBox)
        
        
    }
    
}
