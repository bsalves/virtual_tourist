//
//  MapDataProvider.swift
//  VirtualTourist
//
//  Created by Bruno Soares Alves on 28/02/19.
//  Copyright © 2019 Bruno Soares Alves. All rights reserved.
//

import Foundation

protocol MapDataProvider: class {
    var delegate: MapDataProviderDelegate? { get set }
    func fetchData()
}

protocol MapDataProviderDelegate: class {
    func mapData(_ mapData: MapDataProvider, didFinishedLoad pins: [PinModel])
    func pinRemoved(_ remainingPins: [PinModel])
}
