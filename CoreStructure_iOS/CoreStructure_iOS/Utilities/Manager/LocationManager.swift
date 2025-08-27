//
//  LocationManager.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 26/2/25.
//

import UIKit
import CoreLocation

enum DistanceUnit {
    case meters
    case kilometers
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
        locationManager.distanceFilter = 10 // 🔥 Update location every 10 meters
    }

    // MARK: - Public Methods

    /// Start getting current or continuous location
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

    /// Set a custom distance filter (e.g. 5 meters, 50 meters)
    func setDistanceFilter(_ meters: CLLocationDistance) {
        locationManager.distanceFilter = meters
    }

    /// Stop updating location manually
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
        locationCompletion = nil
        isContinuousUpdate = false
    }

    /// Calculate distance between two locations
    func distance(from fromLocation: CLLocation, to toLocation: CLLocation, unit: DistanceUnit) -> Double {
        let distanceInMeters = fromLocation.distance(from: toLocation)

        switch unit {
        case .kilometers:
            return distanceInMeters / 1000.0
        case .meters:
            return distanceInMeters
        }
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.last else {
            locationCompletion?(nil)
            return
        }

        locationCompletion?(latestLocation)

        if !isContinuousUpdate {
            stopUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("❌ Failed to get location: \(error.localizedDescription)")
        locationCompletion?(nil)
        locationCompletion = nil
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            if shouldStartAfterAuthorization {
                shouldStartAfterAuthorization = false
                locationManager.startUpdatingLocation()
            }
        case .denied, .restricted:
            locationCompletion?(nil)
            locationCompletion = nil
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
}
