//
//  GeolocationData.swift
//  UdacityVirtualTourist
//
//  Created by Marius Chelariu on 13/04/2020.
//  Copyright © 2020 Marius Chelariu. All rights reserved.
//

import Foundation

struct Photo: Codable {
    var id: String
    var owner: String
    var secret: String
    var server: String
    var farm: Int
    var title: String
    var isPublic: Int?
    var isFriend: Int?
    var isFamily: Int?
    var imageData: Data?
}

struct GeolocationData:Codable {
    var photo:[Photo]
    var pages:Int
    var perpage: Int
    var total:String
}
