//
//  GeneralContants.swift
//  OnTheMap
//
//  Created by Marius Chelariu on 05/04/2020.
//  Copyright © 2020 Marius Chelariu. All rights reserved.
//

import Foundation

enum EndPoints: String {
    case session = "session"
    case student = "StudentLocation?limit=100"
}

struct GeneralConstants {
    static let baseUrl:String = "https://onthemap-api.udacity.com/v1/"
}
