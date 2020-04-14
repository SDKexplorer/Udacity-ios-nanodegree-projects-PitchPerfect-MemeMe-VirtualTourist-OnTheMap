//
//  HttpClient.swift
//  OnTheMap
//
//  Created by Marius Chelariu on 05/04/2020.
//  Copyright © 2020 Marius Chelariu. All rights reserved.
//
//
//import Foundation
//
//enum RequestType: String {
//    case get = "GET"
//    case post = "POST"
//    case delete = "DELETE"
//}
//
//class HttpClient {
//    
//    
//    
//    func request<T>(urlString: String, requestType: RequestType, body: Codable) {
//        var request = URLRequest(url: URL(string: urlString)!)
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpMethod = requestType.rawValue
//        if let content = body {
//            let encoder = JSONEncoder()
//            let data = try encoder.encode(body)
//            let string = String(data: data, encoding: .utf8)!
//            request.httpBody = JSONSerialization.
//        }
//        let session = URLSession.shared
//        let task = session.dataTask(with: request) { data, response, error in
//          if error != nil { // Handle error…
//              return
//          }
//          let range = (5..<data!.count)
//          let newData = data?.subdata(in: range) /* subset response data! */
//          print(String(data: newData!, encoding: .utf8)!)
//        }
//        task.resume()
//    }
//}
