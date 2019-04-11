//
//  CollectionViewModel.swift
//  VirtualTourist
//
//  Created by Bruno Alves on 10/03/19.
//  Copyright © 2019 Bruno Soares Alves. All rights reserved.
//

import UIKit

protocol CollectionViewModelDelegate: class {
    func collectionViewModel(_ collectionViewMode: CollectionViewModel, didLoadAlbum withPhotos: [FlickrPhotosModel])
}

class CollectionViewModel {
    
    weak var delegate: CollectionViewModelDelegate?
    private lazy var remoteData = CollectionDataRemote()
    
    var images: [UIImage]?
    
    
//    init(pin: PinModel) {
//
//    }
    
//    func loadPhoto(withPlace: PinModel) {
//        remoteData.fetchFlickrImages(with: withPlace, success: { (data) in
//            //success
//            do {
//                var json = try JSONDecoder().decode(FlickrSearchModel.self, from: data)
//                print(json)
//            } catch {
//                //XCTFail()
//            }
//        }) {
//            //fail
//        }
//    }
    
}
