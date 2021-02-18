//
//  FavouriteGameCell.swift
//  GXchange
//
//  Created by Danabek Abildayev on 12.02.2021.
//  Copyright © 2021 macbook. All rights reserved.
//

import UIKit

class FavouriteGameCell : UICollectionViewCell {
    
    static let identifier = "FavouriteGameCell"
    
    var gameImage : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var name : UILabel = {
        let name = UILabel()
        name.text = "Test Sting Game Name long"
        name.font = .systemFont(ofSize: 19)
        name.numberOfLines = 0
        return name
    }()
    
    var price : UILabel = {
        let price = UILabel()
        price.text = "15000"
        price.font = .systemFont(ofSize: 19)
        return price
    }()
    
    var city : UILabel = {
        let city = UILabel()
        city.text = "The city"
        city.font = .systemFont(ofSize: 19)
        return city
    }()
    
    var phone : UILabel = {
        let phone = UILabel()
        phone.text = "Some number"
        phone.font = .systemFont(ofSize: 19)
        return phone
    }()
    
    var exchangeLabel : UILabel = {
        let exchangeLabel = UILabel()
        exchangeLabel.text = "Exchangeable:"
        exchangeLabel.font = .systemFont(ofSize: 19)
        return exchangeLabel
    }()
    
    let checkboxImage : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let favouriteButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(gameImage)
        contentView.addSubview(name)
        contentView.addSubview(price)
        contentView.addSubview(city)
        contentView.addSubview(phone)
        contentView.addSubview(exchangeLabel)
        contentView.addSubview(checkboxImage)
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
        
        gameImage.frame = CGRect(x: 0, y: 0, width: contentView.frame.width/2, height: contentView.frame.height)
        name.frame = CGRect(x: contentView.frame.width/2 + 10, y: 10, width: contentView.frame.width/2 - 55, height: 50)
        favouriteButton.frame = CGRect(x: contentView.frame.width - 40, y: 10, width: 35, height: 30)
        price.frame = CGRect(x: contentView.frame.width/2 + 10, y: 60, width: contentView.frame.width/2 - 10, height: 20)
        city.frame = CGRect(x: contentView.frame.width/2 + 10, y: 85, width: contentView.frame.width/2 - 10, height: 20)
        phone.frame = CGRect(x: contentView.frame.width/2 + 10, y: 112, width: contentView.frame.width/2 - 10, height: 20)
        exchangeLabel.frame = CGRect(x: contentView.frame.width/2 + 10, y: 139, width: contentView.frame.width/2 - 10, height: 20)
        checkboxImage.frame = CGRect(x: contentView.frame.width - 40, y: 139, width: 20, height: 20)
    }
    
    func putGameImage (from urlString : String?) {
        if urlString != nil {
            gameImage.image = UIImage(named: "psn")
//            print("Now downloading image with url \(urlString!)")
            guard let url = URL(string: urlString!) else {
                print("Unable to convert urlString from firestore to URL")
                return
            }
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, _, error) in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async {
                    self.gameImage.image = UIImage(data: data)
//                    print("Game image should now change")
                }
            }
            task.resume()
        }
    }
    
}
