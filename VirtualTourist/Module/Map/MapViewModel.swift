//
//  MapViewModel.swift
//  VirtualTourist
//
//  Created by Bruno Soares Alves on 28/02/19.
//  Copyright © 2019 Bruno Soares Alves. All rights reserved.
//

import Foundation

protocol MapViewModelDelegate: class {
    func viewModel(_ viewModel: MapViewModel, didLoaded pins: [PinModel])
    func viewModel(_ viewModel: MapViewModel, didLoaded photos: FlickrSearchModel)
}

class MapViewModel: NSObject {
    
    weak var delegate: MapViewModelDelegate?
    private lazy var remoteData = CollectionDataRemote()
    
    private lazy var dataProvider = MapDataLocal()
    
    override init() {
        super.init()
        dataProvider.delegate = self
    }
    
    func loadPins() {
        dataProvider.loadAllData()
    }
    
    func loadPhotos(_ pin: PinModel) {
        dataProvider.loadPhotosFromFlickr(pin)
    }
    
    func savePin(latitude: String, longitude: String) {
        let model = PinModel(coordinates: PinModel.Coordinates(latitude: latitude, longitude: longitude))
        
        remoteData.fetchFlickrImages(with: model, success: { [weak self] (data) in
            //success
            do {
                let searchResult = try JSONDecoder().decode(FlickrSearchModel.self, from: data)
                self?.dataProvider.saveData(model, savePhotosFromSearchResults: searchResult)
            } catch {
                //
            }
        }) {
            //fail
        }
        
        
    }
    
    func removePin(latitude: String, longitude: String) {
        let model = PinModel(coordinates: PinModel.Coordinates(latitude: latitude, longitude: longitude))
        dataProvider.deleteData(model)
    }
}

extension MapViewModel: MapDataLocalDelegate {
    func pinRemoved() {
        self.loadPins()
    }
    
    func photosLoaded(_ photos: FlickrSearchModel) {
        delegate?.viewModel(self, didLoaded: photos)
    }
    
    func pinsLoaded(_ pins: [PinModel]) {
        delegate?.viewModel(self, didLoaded: pins)
    }
}

