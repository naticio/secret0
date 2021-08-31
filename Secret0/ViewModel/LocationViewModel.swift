//
//  LocationViewModerl.swift
//  Secret0
//
//  Created by Nat-Serrano on 8/29/21.
//

import Foundation
import CoreLocation

class LocationModel: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    var locationManager = CLLocationManager()
    
    //to determine the authorization status of gelocating the user
    @Published var authorizationState = CLAuthorizationStatus.notDetermined
    
    @Published var placemark: CLPlacemark?
    
//    @Published var restaurants = [Business]() //to host the data pulled from the api call
//    @Published var sights = [Business]()//to host the data pulled from the api call
//
    override init() {
        
        // Init method of NSObject
        super.init()
        
        // Set content model as the delegate of the location manager
        locationManager.delegate = self

        
    }
    
    
    func requestGeolocationPermission() {
        
        // Request permission from the user
        locationManager.requestWhenInUseAuthorization()
    }

    
    // MARK: - Location Manager Delegate Methods
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        //update the authorizationState property
        authorizationState =  locationManager.authorizationStatus
        
        if locationManager.authorizationStatus == .authorizedAlways ||
            locationManager.authorizationStatus == .authorizedWhenInUse {
            
            // We have permission
            // Start geolocating the user, after we get permission
            locationManager.startUpdatingLocation()
        }
        else if locationManager.authorizationStatus == .denied {
            // We don't have permission
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Gives us the location of the user
        let userLocation = locations.first
        
        if userLocation != nil {
            
            // We have a location
            // Stop requesting the location after we get it once
            locationManager.stopUpdatingLocation()
            
            
            // Get the placemark of the user
            let geoCoder = CLGeocoder()
            
            geoCoder.reverseGeocodeLocation(userLocation!) { (placemarks, error) in
                
                // Check that there aren't errors
                if error == nil && placemarks != nil {
                    
                    // Take the first placemark
                    self.placemark = placemarks?.first
                }
            }
            
            // If we have the coordinates of the user, send into Yelp API
//            getBusinesses(category: Constants.sightsKey, location: userLocation!)
//            getBusinesses(category: Constants.restaurantsKey, location: userLocation!)
        }
        
    }
    
   
    
}
