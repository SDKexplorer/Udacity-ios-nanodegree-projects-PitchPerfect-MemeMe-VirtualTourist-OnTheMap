//
//  Constants.swift
//  UdacityVirtualTourist
//
//  Created by Marius Chelariu on 13/04/2020.
//  Copyright © 2020 Marius Chelariu. All rights reserved.
//

import Foundation



class Constants {
    static let apiKey = "b115c91a1da381d38f52168dc2a9d977"
    static let apiSecret = "1b078af8095906f8"
    static let offset = 10000
    static let coreDataModelName = "UdacityVirtualTourist"
    static let imagesPerPage = 30
}


enum Segues: String {
    case toPinDetails = "toPinDetailsSegue"
}

enum UserDefaultsEnum: String {
    case mapRegionCenterLongitude = "CenterLongitude"
    case mapRegionCenterLatitude = "CenterLatitude"
    case mapRegionSpanLatitude = "SpanLatitude"
    case mapRegionSpanLongitude = "SpanLongitude"

}
enum ReuseableIdentifiers: String {
    case pinDetailsCollectionView = "PinImageCollectionViewCell"
}
