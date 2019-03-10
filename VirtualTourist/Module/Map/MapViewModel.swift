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
}

class MapViewModel: NSObject {
    
    weak var delegate: MapViewModelDelegate?
    
    private lazy var dataProvider: MapDataProvider = {
        return MapDataLocal()
    }()
    
    override init() {
        super.init()
        self.dataProvider.delegate = self
    }
    
    func loadPins() {
        dataProvider.fetchData()
    }
}

extension MapViewModel: MapDataProviderDelegate {
    func pinRemoved(_ remainingPins: [PinModel]) {
        delegate?.viewModel(self, didLoaded: remainingPins)
    }
    
    func mapData(_ mapData: MapDataProvider, didFinishedLoad pins: [PinModel]) {
        delegate?.viewModel(self, didLoaded: pins)
    }
}
