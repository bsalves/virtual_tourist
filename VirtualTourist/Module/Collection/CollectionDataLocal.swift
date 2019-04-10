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
    
    private lazy var appDelegate = UIApplication.shared.delegate as? AppDelegate
    private weak var managedContext: NSManagedObjectContext?
    
    init() {
        self.managedContext = appDelegate?.persistentContainer.viewContext
    }
    
    func saveData(_ searchResult: FlickrSearchModel) {
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Pin", in: self.managedContext!) else { return }
        guard let managedContext = self.managedContext else { return }
        
        searchResult.photos.photo.forEach { (photo) in
            
            let newPhoto = NSManagedObject(entity: entity, insertInto: managedContext)
            newPhoto.setValue(photo.farm, forKey: "farm")
            newPhoto.setValue(photo.id, forKey: "id")
            newPhoto.setValue(photo.secret, forKey: "secret")
            newPhoto.setValue(photo.server, forKey: "server")
            newPhoto.setValue("\(photo.id)_\(photo.secret)_q.jpg", forKey: "fileName")
            newPhoto.setValue(false, forKey: "hasSynced")
            
            do {
                try managedContext.save()
            } catch {
                print("Error while trying to save data")
            }
        }
    }
    
    func loadAllData(_ byPin: PinModel) -> FlickrSearchModel? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        fetchRequest.predicate = NSPredicate(format: "ANY Pin.latitude == %@ AND Pin.longitude == %@", byPin.coordinates.latitude, byPin.coordinates.longitude)
        do {
            var values = [FlickrPhotoModel]()
            let result = try self.managedContext?.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                values.append(FlickrPhotoModel(id: data.value(forKey: "id") as! String,
                                               secret: data.value(forKey: "secret") as! String,
                                               server: data.value(forKey: "server") as! String,
                                               farm: data.value(forKey: "farm") as! Int))
            }
            return FlickrSearchModel(photos: FlickrPhotosModel(photo: values))
        } catch {
            print("Failed")
        }
        return nil
    }
}
