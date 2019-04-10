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
    func photosLoaded(_ photos: FlickrSearchModel)
}

class MapDataLocal {
    
    weak var delegate: MapDataLocalDelegate?
    private lazy var appDelegate = UIApplication.shared.delegate as? AppDelegate
    private weak var managedContext: NSManagedObjectContext?
    private lazy var collectionLocalData = CollectionDataLocal()
    
    init() {
        self.managedContext = appDelegate?.persistentContainer.viewContext
    }
    
    func saveData(_ mapData: PinModel, savePhotosFromSearchResults: FlickrSearchModel) {
        
        DispatchQueue.main.async { [unowned self] in
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let newPin = Pin(context: context)
            newPin.latitude = mapData.coordinates.latitude
            newPin.longitude = mapData.coordinates.longitude
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            self.collectionLocalData.saveData(savePhotosFromSearchResults, forPin: newPin)
        }
    }
    
    func loadAllData() -> [PinModel] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        var pin = [PinModel]()
        do {
            let result = try self.managedContext?.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                pin.append(PinModel(coordinates: PinModel.Coordinates(latitude: data.value(forKey: "latitude") as! String, longitude: data.value(forKey: "longitude") as! String)))
            }
            delegate?.pinsLoaded(pin)
        } catch {
            print("Failed")
        }
        return pin
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
            guard let data = try managedContext?.fetch(fetchRequest) else { return }
            
            data.forEach { (item) in
                let objectToDelete = item as! NSManagedObject
                self.managedContext?.delete(objectToDelete)
            }
            
            do{
                try managedContext?.save()
                //self.delegate?.pinRemoved(self.loadAllData())
                return
            } catch {
                print(error)
            }
            
        } catch {
            print(error)
        }
    }
    
}
