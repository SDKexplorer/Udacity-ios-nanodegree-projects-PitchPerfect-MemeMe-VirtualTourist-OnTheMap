//
//  PinSubmissionViewController.swift
//  OnTheMap
//
//  Created by Marius Chelariu on 06/04/2020.
//  Copyright © 2020 Marius Chelariu. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class PinSubmissionViewController: UIViewController, MKMapViewDelegate {
    
    //MARK: - Properties
    var address:String!
    var addressCoordinates: CLLocationCoordinate2D!
    
    //MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var linkTextField: UITextField!
    
    
    //MARK: - LifeCycle hooks
       
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         activityIndicator("Getting coordinates")
        subscribeToKeyboardNotifications()
        _ = coordinates(forAddress: address) { (coord) in
            let pin = MKPointAnnotation()
            pin.coordinate = coord!
            self.addressCoordinates = coord!
            self.mapView.addAnnotation(pin)
            self.mapView.setCenter(coord!, animated: true)
            self.closeActivity()

        }
    }
    
       override func viewDidDisappear(_ animated: Bool) {
           super.viewDidDisappear(animated)
           unsubscribeFromKeyboardNotification()
       }
    
    func coordinates(forAddress address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) {
            (placemarks, error) in
            guard error == nil else {
                self.alert(title: "Invalid geocode", description: "Cannot find address coordinates", style: .alert, actions: [], viewController: nil)
                return
            }
            completion(placemarks?.first?.location?.coordinate)
        }
    }
    
    @IBAction func onSubmitButtonPressed(_ sender: Any) {
        activityIndicator("Posting pin...")
        let studentPostData = StudentPostData();
        studentPostData.firstName = "John"
        studentPostData.lastName = "Doe"
        studentPostData.latitude = addressCoordinates.latitude
        studentPostData.longitude = addressCoordinates.longitude
        studentPostData.mapString = address
        studentPostData.mediaURL = linkTextField.text
        studentPostData.uniqueKey = AuthenticationService.loginSessionData.account.key
        StudentService.post(studentPostData: studentPostData) {
            result in
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "UnwindToMapSegue", sender: self)
                self.closeActivity()
            }
        }
    }
}
