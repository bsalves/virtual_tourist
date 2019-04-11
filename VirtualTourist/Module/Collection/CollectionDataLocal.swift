//
//  CollectionDataLocal.swift
//  VirtualTourist
//
//  Created by Bruno Alves on 10/03/19.
//  Copyright © 2019 Bruno Soares Alves. All rights reserved.
//

import CoreData
import UIKit

class CollectionDataLocal {

    lazy private var remote = CollectionDataRemote()
    
    func preparePhotosToBeSaved(_ searchResult: FlickrSearchModel) -> [Photo] {
        
        var photosToBeSaved = [Photo]()
        
        searchResult.photos.photo.forEach { (photo) in
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let newPhoto = Photo(context: context)
            newPhoto.farm = Int16(photo.farm)
            newPhoto.fileName = "\(photo.id)_\(photo.secret)_q.jpg"
            newPhoto.secret = photo.secret
            newPhoto.server = photo.server
            newPhoto.id = photo.id
            photosToBeSaved.append(newPhoto)
        }
        return photosToBeSaved
    }
    
    func delete(photo: FlickrPhotoModel, deleted: () -> (), failed: () -> ()) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        fetchRequest.predicate = NSPredicate(format: "ANY id = %@", photo.id)
        do {
            let result = try context.fetch(fetchRequest)
            result.forEach { (item) in
                let objectToDelete = item as! NSManagedObject
                context.delete(objectToDelete)
                deleted()
            }
        } catch {
            print("Failed")
            failed()
        }
    }
    
    func persistImage(_ photo: FlickrPhotoModel, imageData: Data) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        fetchRequest.predicate = NSPredicate(format: "ANY id = %@", photo.id)
        
        do {
            let result = try context.fetch(fetchRequest)
            result.forEach { (item) in
                let objectToUpdate = item as! Photo
                objectToUpdate.photo = imageData
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
            }
        } catch {
            print("Failed")
        }
    }
    
    func loadAllData(_ pinModel: PinModel) -> FlickrSearchModel? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        fetchRequest.predicate = NSPredicate(format: "ANY pin.latitude = %@ AND pin.longitude = %@", pinModel.coordinates.latitude, pinModel.coordinates.longitude)
        do {
            var values = [FlickrPhotoModel]()
            let result = try context.fetch(fetchRequest)
            
            for data in result as! [NSManagedObject] {
                values.append(FlickrPhotoModel(id: data.value(forKey: "id") as! String,
                                               secret: data.value(forKey: "secret") as! String,
                                               server: data.value(forKey: "server") as! String,
                                               farm: data.value(forKey: "farm") as! Int,
                                               photo: data.value(forKey: "photo") as? Data))
                
            }
            return FlickrSearchModel(photos: FlickrPhotosModel(photo: values))
        } catch {
            print("Failed")
        }
        return nil
    }
}
