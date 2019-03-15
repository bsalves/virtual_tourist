//
//  CollectionViewModel.swift
//  VirtualTourist
//
//  Created by Bruno Alves on 10/03/19.
//  Copyright © 2019 Bruno Soares Alves. All rights reserved.
//

import Foundation

protocol CollectionViewModelDelegate: class {
    //func viewModel(_ viewModel: MapViewModel, didLoaded pins: [PinModel])
}

class CollectionViewModel: NSObject {
    
    weak var delegate: CollectionViewModelDelegate?
    
    private lazy var dataProvider: CollectionDataProvider = {
        return CollectionDataLocal()
    }()
    
    override init() {
        super.init()
        self.dataProvider.delegate = self
    }
    
    func loadPins() {
        //dataProvider.fetchData()
    }
    
    func savePin(latitude: String, longitude: String) {
        let model = PinModel(coordinates: PinModel.Coordinates(latitude: latitude, longitude: longitude))
        //dataProvider.saveData(model)
    }
    
    func removePin(latitude: String, longitude: String) {
        let model = PinModel(coordinates: PinModel.Coordinates(latitude: latitude, longitude: longitude))
        //dataProvider.deleteData(model)
    }
}

extension CollectionViewModel: CollectionDataProviderDelegate {
    
}
