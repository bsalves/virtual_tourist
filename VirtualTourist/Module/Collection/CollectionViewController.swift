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
    
    // MARK: Properties
    
    public var coordinate: CLLocationCoordinate2D?
    private var pinModel: PinModel?
    private var viewModel: CollectionViewModel!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        
        let pin = PinModel(coordinates: PinModel.Coordinates(latitude: String(describing: coordinate?.latitude), longitude: String(describing: coordinate?.longitude)))
        self.pinModel = pin
        self.viewModel = CollectionViewModel(pin: pin)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPinOnMap()
    }
    
    // MARK: Private methods
    
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

extension CollectionViewController: MKMapViewDelegate {
    
}
