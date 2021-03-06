//
//  GameInfo.swift
//  GXchange
//
//  Created by Danabek Abildayev on 10/6/20.
//  Copyright © 2020 macbook. All rights reserved.
//

import Foundation
import UIKit


struct GameModel {
    
    var name: String
    var price: String
    var city: String?
    var phone: String?
    var isFavourite : Bool
    var gameImageURL : String?
    var exchangeable : Bool

    init(name: String, price: String, isFavourite: Bool, gameImageURL: String?, exchangeable: Bool) {
        self.name = name
        self.price = price
        self.isFavourite = isFavourite
        self.gameImageURL = gameImageURL
        self.exchangeable = exchangeable
    }
    
    init(name: String, price: String, isFavourite: Bool, city: String, phone: String, gameImageURL: String?, exchangeable: Bool) {
        self.name = name
        self.price = price
        self.isFavourite = isFavourite
        self.city = city
        self.phone = phone
        self.gameImageURL = gameImageURL
        self.exchangeable = exchangeable
    }
    
}
