//
//  Fill.swift
//  GasBuddy
//
//  Created by Yuhan Liu on 11/30/21.
//

import CoreLocation
import FirebaseFirestore
import Foundation
import CloudKit
import FirebaseFirestoreSwift

struct Location: Codable {
  var latitude: Double
  var longitude: Double

  init(latitude: Double, longitude: Double) {
    self.latitude = latitude
    self.longitude = longitude
  }

  init(from location: CLLocationCoordinate2D) {
    self.latitude = location.latitude
    self.longitude = location.longitude
  }

  init(from location: GeoPoint) {
    self.latitude = location.latitude
    self.longitude = location.longitude
  }
}

extension CLLocationCoordinate2D {
  init(from location: Location) {
    self.init(latitude: location.latitude, longitude: location.longitude)
  }
}

extension GeoPoint {
  convenience init(from location: Location) {
    self.init(latitude: location.latitude, longitude: location.longitude)
  }
}

struct GasTrip: Codable, Identifiable {
  @DocumentID public var id: String?
  var totalPrice: Double
  var gallons: Double
  var station: String
  var streetAddress: String
  var date: Date
  var location: Location?
}
