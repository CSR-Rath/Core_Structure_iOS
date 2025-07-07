//
//  LocationManager.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 26/2/25.
//

import UIKit
import CoreLocation

enum DistanceEnum{
    case mm
    case km
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    // MARK: - Singleton
    static let shared = LocationManager()
    
    // MARK: - Private properties
    private let locationManager = CLLocationManager()
    private var locationCompletion: ((CLLocation?) -> Void)?
    private var shouldStartAfterAuthorization = false
    private var isContinuousUpdate = false

    // MARK: - Init
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    // MARK: - Public Methods

    /// Request current or continuous location
    func getCurrentLocation(isLiveLocation: Bool = false, completion: @escaping (CLLocation?) -> Void) {
        locationCompletion = completion
        isContinuousUpdate = isLiveLocation

        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .notDetermined:
            shouldStartAfterAuthorization = true
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            completion(nil)
        @unknown default:
            completion(nil)
        }
    }
    
    
    func distancew(formate: DistanceEnum, fromLocation: CLLocation, toLocation: CLLocation) -> Double {

        let distanceMeters = fromLocation.distance(from: toLocation)
        
        if formate == .km{
            let distanceKilometers = distanceMeters / 1000.0
            return  distanceKilometers //String(format: "%.2f km", distanceKilometers)
        }else if formate == .mm {
            // Show in meters (mm)
            return distanceMeters//String(format: "%.0f m", distanceMeters)
        }
        
        return 0
    }

  

    // Stop location updates manually
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
        locationCompletion = nil
        isContinuousUpdate = false
    }

    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latestLocation = locations.last
        locationCompletion?(latestLocation)
        
        if !isContinuousUpdate {
            stopUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
        locationCompletion?(nil)
        locationCompletion = nil
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            if shouldStartAfterAuthorization {
                shouldStartAfterAuthorization = false
                locationManager.startUpdatingLocation()
            }
        } else if status == .denied || status == .restricted {
            locationCompletion?(nil)
            locationCompletion = nil
        }
    }
}
