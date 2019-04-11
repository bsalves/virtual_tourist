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
    @IBOutlet private(set) weak var newCollectionButton: UIBarButtonItem!
    
    // MARK: Properties
    
    public var coordinate: CLLocationCoordinate2D?
    public var photos: FlickrSearchModel?
    private var pinModel: PinModel?
    lazy var remote = CollectionDataRemote()
    lazy var local = CollectionDataLocal()
    var downloadStack = DispatchGroup()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        guard let coordinates = self.coordinate else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        let pin = PinModel(coordinates: PinModel.Coordinates(latitude: String(describing: coordinates.latitude), longitude: String(describing: coordinates.longitude)))
        self.pinModel = pin
        
        downloadStack.notify(queue: DispatchQueue.main) { [unowned self] in
            self.newCollectionButton.isEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPinOnMap()
    }
    
    // MARK: Actions
    
    @IBAction func refetchAlbum(_ sender: Any) {
        guard let model = pinModel else { return }
        self.photos = nil
        collection.reloadData()
        self.local.reloadAlbum(model) { (result) in
            self.photos = result
            
            DispatchQueue.main.async { [weak self] in
                self?.collection.reloadData()
            }
        }
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
