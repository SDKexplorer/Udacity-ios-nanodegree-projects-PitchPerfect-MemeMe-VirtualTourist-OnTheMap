//
//  MemeDisplayViewController.swift
//  MemeMe
//
//  Created by Marius Chelariu on 02/04/2020.
//  Copyright © 2020 Marius Chelariu. All rights reserved.
//

import Foundation
import UIKit

class MemeDisplayViewController : UIViewController {
    
    // MARK: - Properties
    var image: UIImage!
    
    // MARK: - Outlets
    @IBOutlet weak var imagePresenter: UIImageView!
    
    // MARK: - Actions
    
    @IBAction func dismissView(){
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Lifecycle hooks
    override func viewWillAppear(_ animated: Bool) {
        imagePresenter.image = image
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.viewWillAppear(animated)
        if let image = self.image {
            imagePresenter.image = image
        }
    }
}
