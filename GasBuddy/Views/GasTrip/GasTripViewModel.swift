//
//  GasTripViewModel.swift
//  GasBuddy
//
//  Created by Yuhan Liu on 11/30/21.
//

import Combine
import CoreLocation
import FirebaseFirestore
import FirebaseFirestoreSwift

class GasTripViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {

  var authStatus: AuthStatus?

  @Published var totalPriceString: String = ""
  @Published var gallonsString: String = ""
  @Published var stationString: String = ""
  @Published var addressString: String = ""

  private let tripCollection = Firestore.firestore().collection("trips")

  func save(onCompletion: @escaping (Bool) -> Void) {
    guard let uid = authStatus?.uid else {
      print("Not logged in")
      return
    }
    guard let totalPrice = Double(totalPriceString), let gallons = Double(gallonsString) else {
      return
    }
    let location: Location?
    if let lastCoordinate = self.lastLocation?.coordinate {
      location = Location(from: lastCoordinate)
    } else {
      location = nil
    }
    let newTrip = GasTrip(
      userID: uid,
      totalPrice: totalPrice,
      gallons: gallons,
      station: stationString,
      streetAddress: addressString,
      date: Date(),
      location: location)
    _ = try? self.tripCollection.addDocument(
      from: newTrip,
      completion: { error in
        if error != nil {
          onCompletion(false)
        } else {
          onCompletion(true)
        }
      })
  }

  // MARK: location related stuff

  private lazy var locationManager: CLLocationManager = {
    let locationManager = CLLocationManager()
    locationManager.delegate = self
    return locationManager
  }()
  private var lastLocation: CLLocation?

  func requestAuthorization() {
    guard self.locationManager.authorizationStatus == .notDetermined else {
      return
    }
    self.locationManager.requestWhenInUseAuthorization()
  }

  func startUpdatingLocatin() {
    self.locationManager.startUpdatingLocation()
  }

  func stopUpdatingLocation() {
    self.locationManager.stopUpdatingLocation()
  }

  // MARK: CLLocationManagerDelegate

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let lastLocation = locations.last else {
      return
    }
    self.lastLocation = lastLocation
  }

}
