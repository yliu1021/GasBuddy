//
//  LocationViewModel.swift
//  GasBuddy
//
//  Created by Yuhan Liu on 12/23/21.
//

import Foundation
import CoreLocation

enum LocationStatus: Equatable {
  case restricted
  case undefined
  case idle
  case locating
  case located(CLLocation)
}

class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
  
  @Published var status: LocationStatus = .undefined
  
  private lazy var locationManager: CLLocationManager = {
    let manager = CLLocationManager()
    manager.delegate = self
    manager.pausesLocationUpdatesAutomatically = false
    manager.distanceFilter = 50  // 50 meters
    manager.desiredAccuracy = 50  // 50 meters
    return manager
  }()

  override init() {
    super.init()
    self.locationManagerDidChangeAuthorization(self.locationManager)
  }
  
  func startListening() {
    self.status = .locating
    self.locationManager.startUpdatingLocation()
  }
  
  func stopListening() {
    self.locationManager.stopUpdatingLocation()
    self.status = .idle
  }
  
  func authorize() {
    self.locationManager.requestWhenInUseAuthorization()
  }
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    switch manager.authorizationStatus {
    case .restricted, .denied:
      self.status = .restricted
    case .authorizedWhenInUse, .authorizedAlways:
      self.status = .idle
    case .notDetermined:
      self.status = .undefined
    @unknown default:
      break
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let lastLocation = locations.last else {
      return
    }
    self.status = .located(lastLocation)
  }
  
}
