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
        imageView.contentMode = .scaleAspectFill
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
        
    let checkboxImage : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(gameImage)
        contentView.addSubview(name)
        contentView.addSubview(price)
        contentView.addSubview(checkboxImage)
        contentView.backgroundColor = #colorLiteral(red: 0.6719968021, green: 0.9254902005, blue: 0.8990939033, alpha: 1)
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gameImage.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height - 80)
        name.frame = CGRect(x: 5, y: contentView.frame.height - 80, width: contentView.frame.width - 40, height: 50)
        price.frame = CGRect(x: 5, y: contentView.frame.height - 30, width: contentView.frame.width - 50, height: 20)
        checkboxImage.frame = CGRect(x: 90, y: contentView.frame.height - 30, width: 20, height: 20)
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
