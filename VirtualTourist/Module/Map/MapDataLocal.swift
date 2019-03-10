//
//  MapDataLocal.swift
//  VirtualTourist
//
//  Created by Bruno Alves on 10/03/19.
//  Copyright © 2019 Bruno Soares Alves. All rights reserved.
//

import CoreData
import UIKit

class MapDataLocal: MapDataProvider {
    
    weak var delegate: MapDataProviderDelegate?
    private lazy var appDelegate = UIApplication.shared.delegate as? AppDelegate
    private weak var managedContext: NSManagedObjectContext?
    
    init() {
        self.managedContext = appDelegate?.persistentContainer.viewContext
    }
    
    func saveData(_ mapData: PinModel) {
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Pin", in: self.managedContext!) else { return }
        
        let newPin = NSManagedObject(entity: entity, insertInto: self.managedContext!)
        newPin.setValue(mapData.coordinates.latitude, forKey: "latitude")
        newPin.setValue(mapData.coordinates.longitude, forKey: "longitude")
        
        do {
            try managedContext?.save()
        } catch {
            print("Error during save data")
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
        } catch {
            print("Failed")
        }
        return pin
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
                self.delegate?.pinRemoved(self.loadAllData())
                return
            } catch {
                print(error)
            }
            
        } catch {
            print(error)
        }
    }
    
    func fetchData() {
        let pins = self.loadAllData()
        delegate?.mapData(self, didFinishedLoad: pins)
    }
}
