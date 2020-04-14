//
//  Button.swift
//  OnTheMap
//
//  Created by Marius Chelariu on 06/04/2020.
//  Copyright © 2020 Marius Chelariu. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class ButtonView: UIButton {
   @IBInspectable private var color: UIColor?
    override var backgroundColor: UIColor? {
        get { return color }
        set {
            color = newValue
            self.setNeedsLayout() // EDIT 2017-02-03 thank you @BruceLiu
        }
    }

    private lazy var backgroundLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        self.layer.insertSublayer(layer, at: 0)
        return layer
    }()
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundLayer.path = UIBezierPath(rect: self.bounds).cgPath
        backgroundLayer.fillColor = self.backgroundColor?.cgColor
    }
}
