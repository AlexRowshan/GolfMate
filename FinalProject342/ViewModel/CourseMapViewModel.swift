//
//  CourseMapViewModel.swift
//  FinalProject342
//
//  Created by Alex Rowshan on 4/29/24.
//

import Foundation
import SwiftUI
import MapKit

final class CourseMapViewModel: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    private let searchRadius: CLLocationDistance = 5000 // 5 kilometers
    
    @Published var region = MKCoordinateRegion( // The current map region
        center: .init(latitude: 34.1, longitude: -118.1),
        span: .init(latitudeDelta: 0.2, longitudeDelta: 0.2)
    )
    
    @Published var golfCourses: [MKMapItem] = []   // The list of golf courses found
    
    override init() { // Set the location manager
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.setup()
    }
    
    func setup() {   // Sets up the location manager and requests location authorization
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse:
            locationManager.requestLocation()
        case .notDetermined:
            locationManager.startUpdatingLocation()
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    func searchGolfCourses(near location: CLLocation) {  // Searches for golf courses near the given location
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "golf courses"
        request.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: searchRadius, longitudinalMeters: searchRadius)
        
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            guard let response = response else {
                print("Error searching for golf courses: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            self?.golfCourses = response.mapItems
            
            // Set a larger span for the map region
            self?.region = MKCoordinateRegion(
                center: location.coordinate,
                span: .init(latitudeDelta: 0.2, longitudeDelta: 0.2)
            )
        }
    }
}

extension CourseMapViewModel: CLLocationManagerDelegate { // Extends the view model with location manager delegate methods
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {  // Handles changes in location authorization status
        guard .authorizedWhenInUse == manager.authorizationStatus else { return }
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Something went wrong: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) { // Handles updates to the user's location
        locationManager.stopUpdatingLocation()
        locations.last.map {
            region = MKCoordinateRegion(
                center: $0.coordinate,
                span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
            print("Updated region coordinates: \(region.center.latitude), \(region.center.longitude)")
            
            searchGolfCourses(near: $0)
        }
    }
    
    func centerUserLocation() {  // Centers the map on the user's location
        if let userLocation = locationManager.location?.coordinate {
            region = MKCoordinateRegion(center: userLocation, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        }
    }
}
