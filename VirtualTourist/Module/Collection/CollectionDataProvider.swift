//
//  CollectionDataProvider.swift
//  VirtualTourist
//
//  Created by Bruno Alves on 10/03/19.
//  Copyright © 2019 Bruno Soares Alves. All rights reserved.
//

import Foundation

protocol CollectionDataProvider: class {
    var delegate: CollectionDataProviderDelegate? { get set }
    
}

protocol CollectionDataProviderDelegate: class {
    
}
