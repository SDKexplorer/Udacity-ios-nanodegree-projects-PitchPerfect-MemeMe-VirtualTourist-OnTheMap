
//
//  MemeCollectionViewCell.swift
//  MemeMe
//
//  Created by Marius Chelariu on 01/04/2020.
//  Copyright © 2020 Marius Chelariu. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewCell: UICollectionViewCell, MemeCellProtocol {
    
    // MARK: UI Elements
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func setupCell(_ model: Meme) {
        imageView.image = model.memedImage
    }

}
