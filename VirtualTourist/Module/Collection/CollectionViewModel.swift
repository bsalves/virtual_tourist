//
//  CollectionViewModel.swift
//  VirtualTourist
//
//  Created by Bruno Alves on 10/03/19.
//  Copyright © 2019 Bruno Soares Alves. All rights reserved.
//

import Foundation

protocol CollectionViewModelDelegate: class {
}

class CollectionViewModel {
    
    weak var delegate: CollectionViewModelDelegate?
    
    private lazy var remoteDataProvider =  CollectionDataRemote()
    
    
    init(pin: PinModel) {
        
    }
    
    private func loadPhotos() {
        //remoteDataProvider.fetchFlickrImage(with: <#T##FlickrPhotoModel#>, success: <#T##(Data) -> ()#>, fail: <#T##() -> ()#>)
    }
    
}
