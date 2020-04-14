//
//  StudentTableCell.swift
//  OnTheMap
//
//  Created by Marius Chelariu on 05/04/2020.
//  Copyright © 2020 Marius Chelariu. All rights reserved.
//

import Foundation
import UIKit

class StudentTableViewCell : UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var nameTextField: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupView(student: Student){
        nameTextField.text = "\(student.firstName) \(student.lastName)"
    }
    
}
