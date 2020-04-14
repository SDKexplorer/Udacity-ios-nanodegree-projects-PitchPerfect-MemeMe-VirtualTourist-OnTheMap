//
//  SessionData.swift
//  OnTheMap
//
//  Created by Marius Chelariu on 03/04/2020.
//  Copyright © 2020 Marius Chelariu. All rights reserved.
//

import Foundation

struct Session: Codable {
    var id: String!
    var exporation: Date!
}

struct Account: Codable {
    var registered: Bool!
    var key: String!
}

struct LoginSessionData: Codable {
    var account:Account!
    var session:Session!
}
