//
//  StudentService.swift
//  OnTheMap
//
//  Created by Marius Chelariu on 05/04/2020.
//  Copyright © 2020 Marius Chelariu. All rights reserved.
//

import Foundation

class StudentService {
    
    static var repository: [Student]!
    
    static func get( order: Bool? = false, completionHandler: @escaping (_ students: [Student],_ error: Error?) -> ()) {
        var urlString = GeneralConstants.baseUrl + EndPoints.student.rawValue
        if order! {
            urlString += "&order=-updatedAt"
        }
        let request = URLRequest(url: URL(string: urlString)!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil {
              completionHandler([Student](), error)
              return
          }
            do {
                let data = try JSONDecoder().decode(StudentResponseData.self, from: data!)
                repository = data.results
                completionHandler(data.results, nil)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    static func post(studentPostData: StudentPostData, completionHandler: @escaping(Bool)->()) {
        var request = URLRequest(url: URL(string: GeneralConstants.baseUrl + EndPoints.student.rawValue)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonData = try? JSONEncoder().encode(studentPostData)
        request.httpBody = jsonData
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error…
              return
          }
          completionHandler(true)
        }
        task.resume()
    }
}



