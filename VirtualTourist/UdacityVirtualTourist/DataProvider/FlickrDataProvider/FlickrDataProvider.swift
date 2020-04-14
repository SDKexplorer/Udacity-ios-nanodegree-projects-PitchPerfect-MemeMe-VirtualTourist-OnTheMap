//
//  FlickrDataProvider.swift
//  UdacityVirtualTourist
//
//  Created by Marius Chelariu on 13/04/2020.
//  Copyright © 2020 Marius Chelariu. All rights reserved.
//

import Foundation
import UIKit

enum FlickrQueryEnum: String {
    case method = "method"
    case format = "format"
    case bbox = "bbox"
    case apiKey = "api_key"
    case latitude = "lat"
    case longitude = "lon"
    case safeSearch = "safe_search"
    case contentType = "content_type"
    case radius = "radius"
    case perPage = "per_page"
    case page = "page"
}

class FlickrDataProvider {
    
    static let shared:FlickrDataProvider = FlickrDataProvider()
    private init(){}
    
    
    private var queryItemsDictionary: [FlickrQueryEnum: String] =
    [
        FlickrQueryEnum.method: "flickr.photos.search",
        FlickrQueryEnum.format: "json",
        FlickrQueryEnum.apiKey: Constants.apiKey,
        FlickrQueryEnum.safeSearch:"1",
        FlickrQueryEnum.contentType:"1",
        FlickrQueryEnum.bbox: "",
        FlickrQueryEnum.perPage: String(Constants.imagesPerPage),
        FlickrQueryEnum.page: "1"
    ]

    func getBaseURLComponent() -> URLComponents {
        var baseUrlComponents = URLComponents()
        baseUrlComponents.scheme = "https"
        baseUrlComponents.host = "api.flickr.com"
        return baseUrlComponents;
    }
    
    private func generateGeolocationUrl(longitude: Double, latitude: Double, offset: Double, page: String? = nil) -> URL? {
         var baseUrlComponents = self.getBaseURLComponent()
         baseUrlComponents.path = "/services/rest"
         let longCoord = CoordonatesCalculator.longitude(selectedLongitude: longitude, selectedLatitude: latitude, offset: offset)
         let latCoord = CoordonatesCalculator.latitude(selectedLongitude: longitude, selectedLatitude: latitude, offset: offset)
         queryItemsDictionary[.bbox] = "\(longCoord.min),\(latCoord.min),\(longCoord.max),\(latCoord.max)"
         if page != nil {
             queryItemsDictionary[.page] = page
         }
         var queryItems = [URLQueryItem]()
         for query in queryItemsDictionary {
             let queryItem = URLQueryItem(name: query.key.rawValue, value: query.value)
             queryItems.append(queryItem)
         }
         baseUrlComponents.queryItems = queryItems
         guard let url = baseUrlComponents.url else {
             print("error")
             return nil
         }
        return url
    }
    
    func getGeolocationData(longitude: Double, latitude: Double, offset: Double, completionHandler: @escaping (GeolocationData)->(), page: String? = nil) {
        guard let url = generateGeolocationUrl(longitude: longitude, latitude: latitude, offset: offset, page: page) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                return
            }
            let dataRange = data!.subdata(in: 24..<data!.count-14)
            let decoder = JSONDecoder.init()
            do {
                let geolocationData = try decoder.decode(GeolocationData.self, from: dataRange)
                completionHandler(geolocationData)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    
    func downloadPhoto(photo: Photo, completionHandler: @escaping (_ data: Data?)->()) {
        let urlString = "https://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret).jpg"
        downloadPhoto(urlString: urlString, completionHandler: completionHandler)
    }
    
    func downloadPhoto(urlString:String, completionHandler: @escaping (_ data: Data?)->()) {
        let session = URLSession.shared
        let task = session.dataTask(with: URL(string: urlString)!) { (data, response, error) in
            guard error == nil else {
                completionHandler(nil)
                return
            }
            completionHandler(data)
        }
        task.resume()
    }
    
}
