//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Marius Chelariu on 05/04/2020.
//  Copyright © 2020 Marius Chelariu. All rights reserved.
//

import Foundation
import MapKit
import UIKit

class MapViewController: UIViewController, MKMapViewDelegate, LoadDataProtocol {

    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Actions
    @IBAction func unwindToMap(sender: UIStoryboardSegue) {
        loadData()
    }
    
    // MARK: - LifeCycle hooks
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapView.delegate = self
        loadData()
    }
    
    func loadData() {
        self.mapView.removeAnnotations(self.mapView.annotations)
        activityIndicator("Loading pins...")
        StudentService.get { (students, error) in
            if error != nil {
                self.closeActivity()
                self.alert(title: "Network error", description: error?.localizedDescription, style: .alert, actions: [], viewController: nil)
                return
            }
            DispatchQueue.main.async {
                for student in students {
                    let coord = CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: student.latitude)!, longitude: CLLocationDegrees(student.longitude))
                    let pin = MKPointAnnotation()
                    pin.coordinate = coord
                    pin.title = "\(student.firstName) \(student.lastName)"
                    pin.subtitle = student.mediaURL
                    self.mapView.addAnnotation(pin)
                }
                self.closeActivity()
            }

        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKUserLocation) {
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: String(annotation.hash))
            let rightButton = URLButton(type: .infoLight)
            rightButton.urlParameter = annotation.subtitle!
            rightButton.tag = annotation.hash
            rightButton.addTarget(self, action: #selector(onUrlButtonPress), for: .touchUpInside)
            pinView.animatesDrop = true
            pinView.canShowCallout = true
            pinView.rightCalloutAccessoryView = rightButton

            return pinView
        }
        else {
            return nil
        }
    }
    
    @objc func onUrlButtonPress(sender:URLButton){
        let urlString = sender.urlParameter
        self.openUrl(urlString: urlString!)
    }
    
    
}
