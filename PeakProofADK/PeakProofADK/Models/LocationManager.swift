////
////  LocationManager.swift
////  NPF-4
////
////  Created by Taylor Dennison on 11/23/22.
////
//
//import Foundation
//import CoreLocation
//import Combine
//
//class LocationManager: NSObject, ObservableObject {
//    
//    let locationManager = CLLocationManager()
//    private let geocoder = CLGeocoder()
//    
//    
//    let objectWillChange = PassthroughSubject<Void, Never>()
//    
//    //observable property
//    @Published var permissionError: Bool? {
//        willSet {objectWillChange.send()}
//    }
//    
//    @Published var locationError: Bool? {
//        willSet {objectWillChange.send()}
//    }
//    
//    @Published var status: CLAuthorizationStatus? {
//        willSet {objectWillChange.send()}
//    }
//    
//    @Published var location: CLLocation? {
//        willSet {objectWillChange.send()}
//    }
//    
//    @Published var placemark: CLPlacemark? {
//        willSet {objectWillChange.send()}
//    }
//    
//    
//    override init() {
//        super.init()
//        //configure the location manager
//        locationManager.delegate = self
//        
//        //the higher the accuracy, the more battery is used.
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        
//        //request permission
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.requestWhenInUseAuthorization()
//        }
//        
//        locationManager.startUpdatingLocation()
//        
//    } //init
//    
//    private func geocode() {
//        //if we dont have location, just return.
//        guard let location = self.location else {return}
//        
//        //this is an asynchronous process
//        geocoder.reverseGeocodeLocation(location) { (places, error) in
//            if error == nil {
//                //if it exists, get the first place.
//                self.placemark = places?[0]
//                
//            } //no error
//            else {
//                self.placemark = nil
//            }
//        }
//    }//geocode
//    
//}// LocationManager
//
////conform to the protocol with an extension to keep the actual class less crowded.
//extension LocationManager: CLLocationManagerDelegate {
//    //deal with change in authorization status
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        
//        //status is one of our observed properties.
//        status = manager.authorizationStatus
//        
//        switch status {
//        case .restricted:
//            permissionError = true
//            return
//            
//        case .denied:
//            permissionError = true
//            return
//            
//        case .notDetermined:
//            permissionError = true
//            return
//            
//        case .authorizedWhenInUse:
//            permissionError = false
//            return
//            
//        case .authorizedAlways:
//            permissionError = false
//            return
//            
//        case .none:
//            permissionError = true
//            return
//            
//        @unknown default:
//            break
//        } //switch
//    }// change in auth status
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else {return}
//        
//        self.location = location
//        locationError = false
////        geocode()
//    }// did Update Location
//    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        locationError = true
//    }
//    
//}
//
//
