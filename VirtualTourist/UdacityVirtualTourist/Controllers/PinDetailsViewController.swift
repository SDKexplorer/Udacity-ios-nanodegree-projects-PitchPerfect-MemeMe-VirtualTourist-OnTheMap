//
//  PinDetailsViewController.swift
//  UdacityVirtualTourist
//
//  Created by Marius Chelariu on 13/04/2020.
//  Copyright © 2020 Marius Chelariu. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class PinDetailsViewController: UIViewController {
    
    // MARK: - Properties
    
    var selectedPin: PinCD!
    var photos: [Photo] = [Photo]() {
        didSet {
            let shouldHide = self.photos.count == 0 ? false : true
            DispatchQueue.main.async {
                self.noDataLabel.isHidden = shouldHide
            }
        }

    }
    
    var coreDataProvider = (UIApplication.shared.delegate as! AppDelegate).coreDataProvider
    
    // MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    // MARK: - Actions
    @IBAction func onNewCollectionButtonPress(_ sender: Any) {
        loadProviderData(true)
        self.coreDataProvider.saveContext()
    }
    
    
    // MARK: - Lifecycle
        
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        loadData()
    }
    
    func loadData() {
        if selectedPin.hasBeenInitialized {
            loadCoreData()
        } else {
            loadProviderData()
        }
    }
    
    private func loadProviderData(_ deletePreviousData: Bool = false) {
        showAlert(title: "Service data", description: "Data loaded from service", style: .alert, actions: [], viewController: nil, selfClose: true)
        FlickrDataProvider.shared.getGeolocationData(longitude: selectedPin.longitude, latitude: selectedPin.latitude, offset: Double(Constants.offset)) { (geolocationData) in
            self.photos = geolocationData.photo
            if deletePreviousData {
                self.coreDataProvider.deletePhotos(for: geolocationData)
            }
            if self.photos.count == 0 {
                self.showAlert(title: "No images", description: "Unable to find images for this pinned location", style: .alert, actions: [], viewController: nil)
            }
            // TODO update pin initialize && save current browsed page
            for (index, photo) in self.photos.enumerated() {
                self.downloadPhoto(photo: photo) {
                    imageData in
                    let photoCD = PhotoCD(context: self.coreDataProvider.viewContext)
                    photoCD.pin = self.selectedPin
                    photoCD.farm = Int16(photo.farm)
                    photoCD.id = photo.id
                    photoCD.imageData = imageData
                    photoCD.owner = photo.owner
                    photoCD.secret = photo.secret
                    photoCD.server = photo.server
                    photoCD.title = photo.title
                    DispatchQueue.main.async {
                        self.photos[index].imageData = imageData
                        let indexPath = IndexPath(row: index, section: 0)
                        self.collectionView.insertItems(at: [indexPath])
                    }
                }
            }
            self.selectedPin.hasBeenInitialized = true;
            self.coreDataProvider.saveContext()
        }
    }
    
    private func downloadPhoto(photo: Photo, completionHandler: @escaping (_ imageData: Data)->()) {
        FlickrDataProvider.shared.downloadPhoto(photo: photo) { (data) in
            if data == nil {
                return
            }
            completionHandler(data!)
            }
        }
    
    
    private func loadCoreData() {
        showAlert(title: "Core data", description: "Data loaded from core data", style: .alert, actions: [], viewController: nil, selfClose: true)
        let photosCD = selectedPin.photos?.allObjects as! [PhotoCD]
        for (index, photoCD) in photosCD.enumerated() {
            let photo = Photo(id: photoCD.id!, owner: photoCD.owner!, secret: photoCD.secret!, server: photoCD.server!, farm: Int(photoCD.farm), title: photoCD.title!, isPublic: Int(photoCD.isPublic), isFriend: Int(photoCD.isFriend), isFamily: Int(photoCD.isFamily), imageData: photoCD.imageData!)
            photos.append(photo)
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: index, section: 0)
                self.collectionView.insertItems(at: [indexPath])
            }
        }
    }
}


extension PinDetailsViewController: MKMapViewDelegate {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        placePin(coordinates: CLLocationCoordinate2D(latitude: selectedPin.latitude, longitude: selectedPin.longitude))
    }
    
    func placePin(coordinates: CLLocationCoordinate2D) {
        let annotation = MKPointExtension()
        annotation.coordinate = coordinates
        mapView.addAnnotation(annotation)
        mapView.zoomOnCoordinates(coordinates: coordinates, zoomDistance: Constants.offset)
    }
}


extension PinDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseableIdentifiers.pinDetailsCollectionView.rawValue, for: indexPath) as! PinImageCollectionViewCell
        let photo = photos[indexPath.row];
        
            if let data = photo.imageData {
                let image = UIImage(data: data)
                cell.setupView(image: image!)
            }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            let photoToDelete = self.coreDataProvider.getPhoto(photo: self.photos[indexPath.row])!
            self.coreDataProvider.viewContext.delete(photoToDelete)
            self.photos.remove(at: indexPath.row)
            self.collectionView.deleteItems(at: [indexPath])
            self.coreDataProvider.saveContext()
        }
    }
}
