//
//  MapDataLocal.swift
//  VirtualTourist
//
//  Created by Bruno Alves on 10/03/19.
//  Copyright © 2019 Bruno Soares Alves. All rights reserved.
//

import CoreData
import UIKit

protocol MapDataLocalDelegate: class {
    func pinsLoaded(_ pins: [PinModel])
    func pinRemoved()
    func photosLoaded(_ photos: FlickrSearchModel)
}

class MapDataLocal {
    
    weak var delegate: MapDataLocalDelegate?
    private lazy var collectionLocalData = CollectionDataLocal()
    
    func saveData(_ mapData: PinModel, savePhotosFromSearchResults: FlickrSearchModel) {
        DispatchQueue.main.async {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let newPin = Pin(context: context)
            newPin.latitude = mapData.coordinates.latitude
            newPin.longitude = mapData.coordinates.longitude
            
            self.collectionLocalData.preparePhotosToBeSaved(savePhotosFromSearchResults).forEach({ (photo) in
                newPin.addToPhoto(photo)
            })
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
    }
    
    func loadAllData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        var pin = [PinModel]()
        do {
            let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
            let result = try context?.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                pin.append(PinModel(coordinates: PinModel.Coordinates(latitude: data.value(forKey: "latitude") as! String, longitude: data.value(forKey: "longitude") as! String)))
            }
            delegate?.pinsLoaded(pin)
        } catch {
            print("Failed")
        }
    }
    
    func loadPhotosFromFlickr(_ pinModel: PinModel) {
        guard let photos = collectionLocalData.loadAllData(pinModel) else { return }
        delegate?.photosLoaded(photos)
    }
    
    func deleteData(_ pinModel: PinModel) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        fetchRequest.predicate = NSPredicate(format: "latitude = %@ AND longitude = %@", pinModel.coordinates.latitude, pinModel.coordinates.longitude)
        fetchRequest.fetchLimit = 1
        
        do {
            let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
            guard let data = try context?.fetch(fetchRequest) else { return }
            data.forEach { (item) in
                let objectToDelete = item as! NSManagedObject
                context?.delete(objectToDelete)
            }
            
            do{
                try context?.save()
                self.delegate?.pinRemoved()
                return
            } catch {
                print(error)
            }
            
        } catch {
            print(error)
        }
    }
    
    func loadPin(_ pinModel: PinModel) -> Pin? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        fetchRequest.predicate = NSPredicate(format: "latitude = %@ AND longitude = %@", pinModel.coordinates.latitude, pinModel.coordinates.longitude)
        fetchRequest.fetchLimit = 1
        do {
            let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
            guard let data = try context?.fetch(fetchRequest) else { return nil }
            return data[0] as? Pin
        } catch {
            print(error)
            return nil
        }
    }
    
}
