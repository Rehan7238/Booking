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
         
        
        
    }
    
}
    
  
