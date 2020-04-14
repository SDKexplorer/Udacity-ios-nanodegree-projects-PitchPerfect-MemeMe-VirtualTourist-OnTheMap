//
//  AuthenticationService.swift
//  OnTheMap
//
//  Created by Marius Chelariu on 03/04/2020.
//  Copyright © 2020 Marius Chelariu. All rights reserved.
//

import Foundation

class AuthenticationService {
    
    static var loginSessionData: LoginSessionData!
    
    static func login(loginData: LoginFormData, completionHandler: @escaping (Bool, Error?) -> ()) {
        var request = URLRequest(url: URL(string: GeneralConstants.baseUrl + EndPoints.session.rawValue)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let converted = AuthenticationRequestData(udacity: loginData)
        let jsonData = try? JSONEncoder().encode(converted)
        request.httpBody = jsonData
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil {
              completionHandler(false, error)
              return
          }
          let decoder = JSONDecoder()
          let newData = data?.subdata(in: (5..<data!.count))
          let decodedData: LoginSessionData = try! decoder.decode(LoginSessionData.self, from: newData!)
          self.loginSessionData = decodedData
            guard (decodedData.session?.id) != nil else {
                completionHandler(false, nil)
                return
           }
          completionHandler(true, nil)
        }
        task.resume()
   
    }
    
    static func logout(completionHandler: @escaping (Bool, Error?) -> ()) {
        var request = URLRequest(url: URL(string: GeneralConstants.baseUrl + EndPoints.session.rawValue)!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error…
              completionHandler(false, error)
          }
          self.loginSessionData = nil
          completionHandler(true, nil)
        }
        task.resume()
    }
    
    
}

