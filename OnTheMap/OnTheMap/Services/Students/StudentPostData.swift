//
//  StudentPostData.swift
//  OnTheMap
//
//  Created by Marius Chelariu on 06/04/2020.
//  Copyright © 2020 Marius Chelariu. All rights reserved.
//

import Foundation

class StudentPostData: Codable {
    var uniqueKey: String!
    var firstName: String!
    var lastName: String!
    var mapString: String!
    var mediaURL: String!
    var latitude: Double!
    var longitude: Double!
}
