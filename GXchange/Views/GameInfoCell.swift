//
//  GameInfoCell.swift
//  GXchange
//
//  Created by Danabek Abildayev on 10/6/20.
//  Copyright © 2020 macbook. All rights reserved.
//

import UIKit

class GameInfoCell: UITableViewCell {
    
    @IBOutlet weak var gName: UILabel!
    
    @IBOutlet weak var gPrice: UILabel!
    
    @IBOutlet weak var gImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        
    }
   
}
