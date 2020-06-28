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

class socializerMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
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
        configureLocationServices()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func configureLocationServices() {
        locationManager.delegate = self
        
        let status = CLLocationManager.authorizationStatus()
        
        if status == .notDetermined {
            locationManager.requestAlwaysAuthorization()

        } else if status == .authorizedAlways || status == .authorizedWhenInUse{
            beginLocationUpdates(locationManager: locationManager)
            
        }
        
       
            
        }
     private func zoomToLatestLocation(with coordinate: CLLocationCoordinate2D) {
        
        let zoomRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(zoomRegion, animated: true)
    }
    
    private func beginLocationUpdates(locationManager: CLLocationManager) {
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        //let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
        //user?.setLocation(locValue)
    }
    
}

extension socializerMapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print ("Did get latest location")
        
        guard let latestLocation = locations.first else {return}
        
        if currentCoordinate == nil {
            zoomToLatestLocation(with: latestLocation.coordinate)
        }
        
        currentCoordinate = latestLocation.coordinate
    
    }
    func locationManager(_ manager:CLLocationManager, didChangeAuthorization status:CLAuthorizationStatus){
        print ("The status changed")
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            beginLocationUpdates(locationManager: manager)
        }
        
    }
    
}
