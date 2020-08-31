//
//  MapViewController.swift
//  Hotels
//
//  Created by Igor Bopp
//  Copyright © 2020 Igor Bopp. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    // MARK: - Outlet
    @IBOutlet weak var mapView: MKMapView!
    
    // Private
    var location: (lat: Double, lon: Double)!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setPin(location: CLLocationCoordinate2D(latitude: location.lat, longitude: location.lon))
    }
    
    // MARK: - Methods
    func setPin(location: CLLocationCoordinate2D) {
       let annotation = MKPointAnnotation()
       annotation.coordinate = location
       let coordinateRegion = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 800, longitudinalMeters: 800)
       mapView.setRegion(coordinateRegion, animated: true)
       mapView.addAnnotation(annotation)
    }
    
}
