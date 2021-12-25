//
//  GasStationSearchViewModel.swift
//  GasBuddy
//
//  Created by Yuhan Liu on 12/25/21.
//

import Foundation
import CoreLocation
import MapKit

class GasStationSearchViewModel: ObservableObject {
  
  private var search: MKLocalSearch?
  
  func find(near location: CLLocation, onFind: @escaping (MKPlacemark) -> ()) {
    let coord = location.coordinate
    let request = MKLocalPointsOfInterestRequest(center: coord, radius: 50)  // 50 meters
    request.pointOfInterestFilter = MKPointOfInterestFilter(including: [.gasStation])
    self.search?.cancel()
    self.search = MKLocalSearch(request: request)
    print("Finding gas stations: near \(location)")
    self.search?.start { response, error in
      guard let response = response else {
        print("Finding gas station: \(error!)")
        return
      }
      let stations = response
        .mapItems
        .filter { $0.pointOfInterestCategory == .gasStation }
        .map { $0.placemark }
        .filter { $0.location != nil }
        .sorted { placemark1, placemark2 in
          location.distance(from: placemark1.location!) < location.distance(from: placemark2.location!)
        }
      guard let closest = stations.first else {
        print("Finding gas station: no viable stations found")
        return
      }
      onFind(closest)
    }
  }
  
}
