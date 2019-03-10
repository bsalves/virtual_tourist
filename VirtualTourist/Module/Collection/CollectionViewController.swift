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
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
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
        let zoomLocation = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 200, 200)
        map.setRegion(viewRegion, animated: false)
        map.selectAnnotation(point, animated: true)
    }
    
    
}

extension CollectionViewController: MKMapViewDelegate {
    
}
