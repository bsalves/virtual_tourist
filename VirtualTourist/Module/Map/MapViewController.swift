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
    @IBOutlet private(set) weak var deletePinButtonHeightContraint: NSLayoutConstraint!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setup()
    }
    
    // MARK: Private methods
    
    private func setup() {
        self.resetViewState()
    }
    
    private func resetViewState() {
        self.deletePinButtonHeightContraint.constant = 0
        self.view.layoutIfNeeded()
    }
    
}
