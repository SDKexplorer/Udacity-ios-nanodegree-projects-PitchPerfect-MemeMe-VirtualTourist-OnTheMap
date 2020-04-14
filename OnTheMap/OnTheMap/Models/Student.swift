//
//  Student.swift
//  OnTheMap
//
//  Created by Marius Chelariu on 05/04/2020.
//  Copyright © 2020 Marius Chelariu. All rights reserved.
//

import Foundation

class Student: Codable {
    let createdAt: String
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let objectId: String
    let uniqueKey: String
    let updatedAt: String
}
