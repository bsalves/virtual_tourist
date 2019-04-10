//
//  MapViewController.swift
//  VirtualTourist
//
//  Created by Bruno Soares Alves on 28/02/19.
//  Copyright © 2019 Bruno Soares Alves. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet private(set) weak var map: MKMapView!
    @IBOutlet private(set) weak var editButton: UIBarButtonItem!
    @IBOutlet private(set) weak var mapTopAncorContraint: NSLayoutConstraint!
    @IBOutlet private(set) weak var deletePinButtonHeightContraint: NSLayoutConstraint!
    
    // MARK: Properties
    
    private var viewModel = MapViewModel()
    private var coordinatesToPass: CLLocationCoordinate2D?
    private var isEditingMode = false {
        didSet {
            toggleEditingMode()
        }
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.loadPins()
        map.delegate = self
        
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.toggleEditingMode()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let collectionViewController = segue.destination as? CollectionViewController {
            collectionViewController.coordinate = self.coordinatesToPass
        }
    }
    
    // MARK: IBActions
    
    @IBAction func editPins(_ sender: Any?) {
        self.isEditingMode = !self.isEditingMode
    }
    
    // MARK: Private methods
    
    private func setup() {
        let longPressRecognizer: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
        longPressRecognizer.addTarget(self, action: #selector(recognizeLongPress(_:)))
        map.addGestureRecognizer(longPressRecognizer)
    }
    
    private func toggleEditingMode() {
        self.deletePinButtonHeightContraint.constant = (isEditingMode) ? 60 : 0
        self.mapTopAncorContraint.constant = (isEditingMode) ? -60 : 0
        self.editButton.title = (isEditingMode) ? "Ok" : "Editar"
        self.editButton.style = (isEditingMode) ? .done : .plain
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func clearAllPins() {
        map.annotations.forEach { (pin) in
            map.removeAnnotation(pin)
        }
    }
    
    @objc private func recognizeLongPress(_ sender: UILongPressGestureRecognizer) {
        if sender.state != UIGestureRecognizerState.began {
            return
        }
        let location = sender.location(in: map)
        let coordinates: CLLocationCoordinate2D = map.convert(location, toCoordinateFrom: map)
        let pinToDrop: MKPointAnnotation = MKPointAnnotation()
        pinToDrop.coordinate = coordinates
        map.addAnnotation(pinToDrop)
        viewModel.savePin(latitude: String(describing: coordinates.latitude), longitude: String(describing: coordinates.longitude))
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if isEditingMode {
            guard let annotation = view.annotation else {
                return
            }
            viewModel.removePin(latitude: String(describing: annotation.coordinate.latitude), longitude: String(describing: annotation.coordinate.longitude))
        } else {
            self.coordinatesToPass = view.annotation?.coordinate
            performSegue(withIdentifier: "collectionSegue", sender: nil)
            map.deselectAnnotation(view.annotation, animated: true)
        }
    }
}

extension MapViewController: MapViewModelDelegate {
    func viewModel(_ viewModel: MapViewModel, didLoaded pins: [PinModel]) {
        self.clearAllPins()
        pins.forEach { (pin) in
            let point = MKPointAnnotation()
            point.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(pin.coordinates.latitude)!, longitude: CLLocationDegrees(pin.coordinates.longitude)!)
            map.addAnnotation(point)
        }
    }
}
