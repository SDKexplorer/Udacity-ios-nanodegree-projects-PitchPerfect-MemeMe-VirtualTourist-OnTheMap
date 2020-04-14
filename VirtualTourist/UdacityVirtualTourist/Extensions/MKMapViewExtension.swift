//
//  MKMapViewExtension.swift
//  UdacityVirtualTourist
//
//  Created by Marius Chelariu on 13/04/2020.
//  Copyright © 2020 Marius Chelariu. All rights reserved.
//

import Foundation
import MapKit

extension MKMapView {

    
    func zoomOnCoordinates (coordinates: CLLocationCoordinate2D, zoomDistance: Int) {
        let locationDistance = CLLocationDistance(zoomDistance)
        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: locationDistance, longitudinalMeters: locationDistance)
        self.setRegion(region, animated: true)
    }
    
    func zoomOnRegion (region: MKCoordinateRegion) {
        self.setRegion(region, animated: true)
    }
    
}
