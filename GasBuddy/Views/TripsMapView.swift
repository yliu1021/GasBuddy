//
//  TripsMapView.swift
//  GasBuddy
//
//  Created by Yuhan Liu on 12/25/21.
//

import SwiftUI
import MapKit

func trip(hasCoordinates trip: GasTrip) -> Bool {
  return trip.latitude != 0 && trip.longitude != 0
}

extension GasTrip {
  var location: CLLocationCoordinate2D? {
    if self.latitude != 0 && self.longitude != 0 {
      return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    } else {
      return nil
    }
  }
}

struct TripsMapView: View {
  var trips: [GasTrip]
  
  @State private var region: MKCoordinateRegion
  
  init(trips: [GasTrip]) {
    self.trips = trips.filter { $0.location != nil }
    var minLat: CLLocationDegrees = CLLocationDegrees.infinity
    var minLong: CLLocationDegrees = CLLocationDegrees.infinity
    var maxLat: CLLocationDegrees = -CLLocationDegrees.infinity
    var maxLong: CLLocationDegrees = -CLLocationDegrees.infinity
    for trip in self.trips {
      minLat = CLLocationDegrees.minimum(minLat, trip.latitude)
      minLong = CLLocationDegrees.minimum(minLong, trip.longitude)
      maxLat = CLLocationDegrees.maximum(maxLat, trip.latitude)
      maxLong = CLLocationDegrees.maximum(maxLong, trip.longitude)
    }
    let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLong + maxLong) / 2)
    var span = MKCoordinateSpan(latitudeDelta: maxLat - minLat, longitudeDelta: maxLong - minLong)
    span.latitudeDelta += 200 / 100_000
    span.longitudeDelta += 200 / 100_000
    self.region = MKCoordinateRegion(center: center, span: span)
  }
  
  var body: some View {
    if self.trips.isEmpty {
      Text("No Trips to show")
    } else {
      Map(
        coordinateRegion: self.$region,
        interactionModes: [.pan, .zoom],
        annotationItems: self.trips) { trip in
          MapMarker(coordinate: trip.location!, tint: Color.red)
        }
    }
  }
}

struct TripsMapView_Previews: PreviewProvider {
  @Environment(\.managedObjectContext) static private var viewContext
  @FetchRequest(
    entity: GasTrip.entity(),
    sortDescriptors: [NSSortDescriptor(keyPath: \GasTrip.date, ascending: false)],
    animation: Animation.default
  ) static private var fetchedTrips: FetchedResults<GasTrip>
  
  static var trips: [GasTrip] {
    return fetchedTrips.compactMap { $0 }
  }
  
  static var previews: some View {
    TripsMapView(trips: self.trips)
      .environment(
        \.managedObjectContext,
         PersistenceController.preview.container.viewContext)
  }
}
