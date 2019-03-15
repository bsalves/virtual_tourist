//
//  PhotoRequestTests.swift
//  VirtualTouristTests
//
//  Created by Bruno Soares Alves on 15/03/19.
//  Copyright © 2019 Bruno Soares Alves. All rights reserved.
//

import XCTest
@testable import VirtualTourist

class PhotoRequestTests: XCTestCase {
    
    var remoteData = CollectionDataRemote()
    var photoModel = FlickrPhotoModel(id: "40419480693", secret: "f624cca791", server: "7876", farm: 8)
    var pinModel = PinModel(coordinates: PinModel.Coordinates(latitude: "-23.5489", longitude: "-46.6388"))
    
    
    func testFetchImages() {
        let promise = expectation(description: "remote")
        
        remoteData.fetchFlickrImages(with: pinModel, success: { (data) in
            //
            do {
                var json = try JSONDecoder().decode(FlickrSearchModel.self, from: data)
                print(json)
            } catch let jsonErr {
                XCTFail()
            }
            promise.fulfill()
        }) {
            XCTFail()
            promise.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testDownloadData() {
        let promise = expectation(description: "remote")
        remoteData.fetchFlickrImage(with: photoModel, success: { (data) in
            print(data)
            promise.fulfill()
        }) {
            print("erro")
            XCTFail()
            promise.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
}
