//
//  MemeTableViewCell.swift
//  MemeMe
//
//  Created by Marius Chelariu on 01/04/2020.
//  Copyright © 2020 Marius Chelariu. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewCell : UITableViewCell, MemeCellProtocol {
    
    // MARK: UI Elements
    @IBOutlet weak var topTextLabel: UILabel!
    @IBOutlet weak var bottomTextLabel: UILabel!
    @IBOutlet weak var imageViewElement: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func setupCell(_ model: Meme) {
        topTextLabel.text = model.topText
        bottomTextLabel.text = model.bottomText
        imageView?.image = model.memedImage
    }
}

