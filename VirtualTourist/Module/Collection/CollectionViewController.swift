//
//  CollectionViewController.swift
//  VirtualTourist
//
//  Created by Bruno Alves on 10/03/19.
//  Copyright © 2019 Bruno Soares Alves. All rights reserved.
//

import UIKit
import MapKit

class CollectionViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet private(set) weak var map: MKMapView!
    @IBOutlet private(set) weak var collection: UICollectionView!
    @IBOutlet private(set) weak var collectionViewLayoutFlow: UICollectionViewFlowLayout!
    
    // MARK: Properties
    
    public var coordinate: CLLocationCoordinate2D?
    public var photos: FlickrSearchModel?
    private var pinModel: PinModel?
    lazy var remote = CollectionDataRemote()
    lazy var local = CollectionDataLocal()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        
        let pin = PinModel(coordinates: PinModel.Coordinates(latitude: String(describing: coordinate?.latitude), longitude: String(describing: coordinate?.longitude)))
        self.pinModel = pin
//        self.viewModel = CollectionViewModel(pin: pin)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPinOnMap()
    }
    
    // MARK: Private methods
    
    private func setupCollectionView() {
        collection.delegate = self
        collection.dataSource = self
        collectionViewLayoutFlow.scrollDirection = .vertical
        collectionViewLayoutFlow.minimumLineSpacing = 1
        collectionViewLayoutFlow.minimumInteritemSpacing = 1
    }
    
    private func loadPinOnMap() {
        guard let coordinate = self.coordinate else { return }
        
        let point = MKPointAnnotation()
        point.coordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        map.addAnnotation(point)
        let viewRegion = MKCoordinateRegionMakeWithDistance(coordinate, 200, 200)
        map.setRegion(viewRegion, animated: false)
        map.selectAnnotation(point, animated: true)
    }
    
}
