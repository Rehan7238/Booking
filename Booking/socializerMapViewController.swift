//
//  socializerMapViewController.swift
//  Booking
//
//  Created by Eimara Mirza on 6/28/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import FirebaseAuth
import Mapbox
import MapboxNavigation
import MapboxDirections

class socializerMapViewController: UIViewController, MGLMapViewDelegate {
    
    @IBOutlet weak var mapView: MGLMapView!
    var user: User?
    
    private let locationManager = CLLocationManager()
    private var currentCoordinate : CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let uid = Auth.auth().currentUser?.uid {
            _ = User.fromID(id: uid).done { loadedUser in
                self.user = loadedUser
            }
        }
        mapView = NavigationMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        
        
    // Add a point annotation
        let annotation = MGLPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 40.77014, longitude: -73.97480)
        annotation.title = "Central Park"
        annotation.subtitle = "The biggest park in New York City!"
        mapView.addAnnotation(annotation)
        
        
    }
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
    // Always allow callouts to popup when annotations are tapped.
    return true
    }
    
}
    
  
