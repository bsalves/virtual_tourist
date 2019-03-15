////
////  PinsLocalDataTests.swift
////  VirtualTouristTests
////
////  Created by Bruno Alves on 10/03/19.
////  Copyright © 2019 Bruno Soares Alves. All rights reserved.
////
//
//import XCTest
//@testable import VirtualTourist
//
//class PinsLocalDataTests: XCTestCase, MapDataProviderDelegate {
//    
//    var localData: MapDataLocal?
//    var pinModelTest: PinModel?
//    
//    override func setUp() {
//        super.setUp()
//        localData = MapDataLocal()
//        localData?.delegate = self
//        pinModelTest = PinModel(coordinates: PinModel.Coordinates(latitude: "0", longitude: "0"))
//    }
//    
//    override func tearDown() {
//        localData = nil
//        super.tearDown()
//    }
//    
//    func testSavePin() {
//        localData?.saveData(pinModelTest!)
//        localData?.fetchData()
//    }
//    
//    func mapData(_ mapData: MapDataProvider, didFinishedLoad pins: [PinModel]) {
//        print(pins)
//        XCTAssert(pins.count > 0)
//        localData?.deleteData(latitude: (pinModelTest?.coordinates.latitude)!, longitude: (pinModelTest?.coordinates.longitude)!)
//    }
//    
//    func pinRemoved(_ remainingPins: [PinModel]) {
//        print(remainingPins)
//        XCTAssert(remainingPins.count == 0)
//    }
//}
