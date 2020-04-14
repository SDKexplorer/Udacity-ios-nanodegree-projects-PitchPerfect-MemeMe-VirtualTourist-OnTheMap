//
//  ViewController.swift
//  UdacityVirtualTourist
//
//  Created by Marius Chelariu on 13/04/2020.
//  Copyright © 2020 Marius Chelariu. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    // MARK: - Properties
    var pins: [PinCD] = [PinCD]()
    var coreDataProvider = (UIApplication.shared.delegate as! AppDelegate).coreDataProvider
    
    // MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    

    
    // MARK: - Lifecycle
    override func viewDidLoad(){
        super.viewDidLoad()
        loadData()
    }
    
    // MARK: - Methods
    func loadData () {
        pins = coreDataProvider.getPins()
    }
    
}

extension MapViewController: MKMapViewDelegate {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.viewDidLoad()
        mapView.delegate = self
        registerGestures()
        renderPins()
        loadMapPostion()
    }
    
    func renderPins() {
        for pin in pins {
            let coordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: pin.latitude)!, longitude: CLLocationDegrees(exactly: pin.longitude)!)
            addAnnotation(coordinates: coordinates, pin: pin)
        }
    }
    
    private func registerGestures() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(mapLongPressEnded))
        gesture.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(gesture)
    }
    
    @objc func mapLongPressEnded(gestureRecognizer: UIGestureRecognizer){
        if gestureRecognizer.state == .ended {
            let touchPoint = gestureRecognizer.location(in: mapView)
            let coordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            let pin = savePinToCoreData(coordinates: coordinates)
            addAnnotation(coordinates: coordinates, pin: pin)
        }
    }
    
    private func savePinToCoreData(coordinates: CLLocationCoordinate2D) -> PinCD{
        let pin = PinCD(context: coreDataProvider.viewContext)
        pin.latitude = coordinates.latitude
        pin.longitude = coordinates.longitude
        coreDataProvider.saveContext()
        pins.append(pin)
        return pin;
    }
    
    func addAnnotation(coordinates: CLLocationCoordinate2D, pin: PinCD) {
        let annotation = MKPointExtension()
        annotation.coordinate = coordinates
        annotation.pin = pin
        mapView.addAnnotation(annotation)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        performSegue(withIdentifier: Segues.toPinDetails.rawValue, sender: view.annotation)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        saveMapPosition()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.toPinDetails.rawValue {
            let viewController = segue.destination as! PinDetailsViewController
            let sender = sender as! MKPointExtension
            viewController.selectedPin = sender.pin
        }
    }
    
    func saveMapPosition() {
        let region = mapView.region
        let userDefaults = UserDefaults.standard
        userDefaults.set(region.center.latitude, forKey: UserDefaultsEnum.mapRegionCenterLatitude.rawValue)
        userDefaults.set(region.center.longitude, forKey: UserDefaultsEnum.mapRegionCenterLongitude.rawValue)
        userDefaults.set(region.span.latitudeDelta, forKey: UserDefaultsEnum.mapRegionSpanLatitude.rawValue)
        userDefaults.set(region.span.longitudeDelta, forKey: UserDefaultsEnum.mapRegionSpanLongitude.rawValue)
    }
    
    
    func loadMapPostion() {
        let userDefaults = UserDefaults.standard
        guard let centerLat = userDefaults.value(forKey: UserDefaultsEnum.mapRegionCenterLatitude.rawValue) else {
            return
        }
        guard let centerLon = userDefaults.value(forKey: UserDefaultsEnum.mapRegionCenterLongitude.rawValue) else {
            return
        }
        guard let spanLat = userDefaults.value(forKey: UserDefaultsEnum.mapRegionSpanLatitude.rawValue) else {
            return
        }
        guard let spanLon = userDefaults.value(forKey: UserDefaultsEnum.mapRegionSpanLongitude.rawValue) else {
            return
        }
        
        do {
            let region = try MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: CLLocationDegrees(exactly: centerLat as! Double)!,
                    longitude: CLLocationDegrees(exactly: centerLon  as! Double)!
                ),
                span: MKCoordinateSpan(
                    latitudeDelta: CLLocationDegrees(exactly: spanLat  as! Double)!,
                    longitudeDelta: CLLocationDegrees(exactly: spanLon  as! Double)!
                )
            )
            DispatchQueue.main.async {
                self.mapView.setRegion(region, animated: true)
            }
        } catch {
            print(error.localizedDescription)
        }

        
        
    }
}
