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
    var photoModel = FlickrPhotoModel(id: "47568770471", secret: "030e624f14", server: "7806", farm: 8)
    var pinModel = PinModel(coordinates: PinModel.Coordinates(latitude: "-23.5349283592817", longitude: "-46.7074641683413"))
    
    
    func testFetchImages() {
        let promise = expectation(description: "remote")
        
        remoteData.fetchFlickrImages(with: pinModel, success: { (data) in
            //
            do {
                var json = try JSONDecoder().decode(FlickrSearchModel.self, from: data)
                print(json)
            } catch {
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
