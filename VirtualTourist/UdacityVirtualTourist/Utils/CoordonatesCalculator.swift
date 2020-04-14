//
//  CoordonatesCalculator.swift
//  UdacityVirtualTourist
//
//  Created by Marius Chelariu on 13/04/2020.
//  Copyright © 2020 Marius Chelariu. All rights reserved.
//

import Foundation

struct MinMaxCoord {
    var max: Double
    var min: Double
    
}

class CoordonatesCalculator {

    private static var earth = 6378.137
    
    static func longitude(selectedLongitude: Double, selectedLatitude: Double, offset: Double) -> MinMaxCoord{
        let m = (1 / ((2 * Double.pi / 360) * earth)) / 1000;  //1 meter in degree
        let offset = (offset * m) / cos(selectedLatitude * (Double.pi / 180));
        return MinMaxCoord(max: selectedLongitude+offset, min: selectedLongitude-offset)
    }
    
    static func latitude(selectedLongitude: Double, selectedLatitude: Double, offset: Double) -> MinMaxCoord{
        let m = (1 / ((2 * Double.pi / 360) * earth)) / 1000;  //1 meter in degree
        let offset = offset * m;
        return MinMaxCoord(max: selectedLatitude+offset, min: selectedLatitude-offset)
    }
}
