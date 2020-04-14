//
//  CoreDataProvider.swift
//  UdacityVirtualTourist
//
//  Created by Marius Chelariu on 13/04/2020.
//  Copyright © 2020 Marius Chelariu. All rights reserved.
//

import Foundation
import CoreData

class CoreDataProvider {
    
    // MARK: - Properties
    
    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    let container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.coreDataModelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //  MARK: - Methods
    
    func getPins() -> [PinCD] {
        let fetchRequest:NSFetchRequest = PinCD.fetchRequest()
        return try! viewContext.fetch(fetchRequest)
    }
    
    func getPhoto(photo: Photo) -> PhotoCD? {
        let fetchRequest:NSFetchRequest = PhotoCD.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", photo.id)
        fetchRequest.predicate = predicate
        do {
            return try viewContext.fetch(fetchRequest).first
        } catch {
            return nil
        }
    }
    
    func deletePhotos(for pin: GeolocationData) {
        for photo in pin.photo {
            if let photoCD = getPhoto(photo: photo) {
                viewContext.delete(photoCD)
            }
        }
    }
    //
    //    func getPhotos(pin: Pin) -> [PinPhoto] {
    //        let fetchRequest:NSFetchRequest = PinPhoto.fetchRequest()
    //        let predicate = NSPredicate(format: "pin == %@", pin)
    //
    //        fetchRequest.predicate = predicate
    //        return try! viewContext.fetch(fetchRequest)
    //    }
    //
    //    func addPhoto(pin: Pin, photoUrl: String) {
    //        let photo = PinPhoto(context: viewContext)
    //        photo.url = photoUrl
    //        photo.pin = pin
    //        saveContext()
    //    }
    //
    //    func updatePhoto(pinPhoto: PinPhoto, hasBeenRemoved: Bool) {
    //        pinPhoto.hasBeenRemoved = hasBeenRemoved
    //        saveContext()
    //    }
    
    
}
