//
//  LocationView.swift
//  GasBuddy
//
//  Created by Yuhan Liu on 12/23/21.
//

import SwiftUI
import CoreLocation

extension BinaryFloatingPoint {
  var dms: (degrees: Int, minutes: Int, seconds: Int) {
    var seconds = Int(self * 3600)
    let degrees = seconds / 3600
    seconds = abs(seconds % 3600)
    return (degrees, seconds / 60, seconds % 60)
  }
}

extension CLLocation {
  var dms: String { latitude + " " + longitude }
  var latitude: String {
    let (degrees, minutes, seconds) = coordinate.latitude.dms
    return String(format: "%d°%d'%d\"%@", abs(degrees), minutes, seconds, degrees >= 0 ? "N" : "S")
  }
  var longitude: String {
    let (degrees, minutes, seconds) = coordinate.longitude.dms
    return String(format: "%d°%d'%d\"%@", abs(degrees), minutes, seconds, degrees >= 0 ? "E" : "W")
  }
}

struct LocationView: View {
  
  @ObservedObject var locationState: LocationViewModel
  
  var body: some View {
    Group {
      switch locationState.status {
      case .idle:
        Text("Idle")
      case .restricted:
        Text("Location restricted")
      case .undefined:
        Text("")
      case .locating:
        Text("Locating...")
      case .located(let location):
        Text("Located: \(location.dms)")
      }
    }
    .font(.caption)
    .onAppear {
      self.locationState.authorize()
      print("Started listening for location updates")
      self.locationState.startListening()
    }
    .onDisappear {
      print("Stopped listening for location updates")
      self.locationState.stopListening()
    }
  }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView(locationState: LocationViewModel())
    }
}
