//
//  LoggedInViewController.swift
//  GXchange
//
//  Created by Danabek Abildayev on 13.02.2021.
//  Copyright © 2021 macbook. All rights reserved.
//

import UIKit

class LoggedInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemTeal
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        label.text = "Congratulations! \nYou have successfully logged in."
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 30)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                     label.widthAnchor.constraint(equalToConstant: 350),
                                     label.heightAnchor.constraint(equalToConstant: 250)])

        // Do any additional setup after loading the view.
    }

}
