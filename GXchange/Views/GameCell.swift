//
//  CollectionViewCell.swift
//  GXchange
//
//  Created by Danabek Abildayev on 2/6/21.
//  Copyright © 2021 macbook. All rights reserved.
//

import UIKit

class GameCell: UICollectionViewCell {
    
    static let identifier = "GameCell"
    
    var gameImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "psn")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var name : UILabel = {
        let name = UILabel()
        name.text = "Test Sting Game Name long"
        name.numberOfLines = 0
        return name
    }()
    
    var price : UILabel = {
        let price = UILabel()
        price.text = "15000"
        price.font = .systemFont(ofSize: 19)
        return price
    }()
    
    let favouriteButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(gameImage)
        contentView.addSubview(name)
        contentView.addSubview(price)
        contentView.backgroundColor = #colorLiteral(red: 0.6719968021, green: 0.9254902005, blue: 0.8990939033, alpha: 1)
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        
        favouriteButton.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
        contentView.addSubview(favouriteButton)
        
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gameImage.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height - 80)
        name.frame = CGRect(x: 5, y: contentView.frame.height - 80, width: contentView.frame.width - 40, height: 50)
        favouriteButton.frame = CGRect(x: contentView.frame.width - 40, y: 5, width: 35, height: 30)
        price.frame = CGRect(x: 5, y: contentView.frame.height - 30, width: contentView.frame.width - 10, height: 20)
    }
    
}
