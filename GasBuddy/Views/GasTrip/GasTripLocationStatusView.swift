//
//  GasTripLocationStatusView.swift
//  GasBuddy
//
//  Created by Yuhan Liu on 12/2/21.
//

import CoreLocation
import SwiftUI

struct GasTripLocationStatusView: View {
  @Binding var locationStatus: LocationStatus
  var body: some View {
    Group {
      switch locationStatus {
      case .notAuthorized:
        Text("Location services not authorized")
          .foregroundColor(Color.red)
      case .idle:
        Text("")
      case .locating:
        HStack {
          ProgressView().progressViewStyle(CircularProgressViewStyle())
          Text("Locating...")
        }
      case .locatedNoAddress(let location), .locatedWithAddess(let location, _, _):
        Text("Located: \(location)")
      }
    }.font(.caption)
  }
}

struct GasTripLocationStatusView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      GasTripLocationStatusView(
        locationStatus: .constant(.notAuthorized))
      GasTripLocationStatusView(
        locationStatus: .constant(.idle))
      GasTripLocationStatusView(
        locationStatus: .constant(.locating))
      GasTripLocationStatusView(
        locationStatus: .constant(.locatedNoAddress(CLLocation(latitude: 123, longitude: 23))))
      GasTripLocationStatusView(
        locationStatus: .constant(.locatedNoAddress(CLLocation(latitude: 123, longitude: 23))))
    }.previewLayout(.sizeThatFits)
      .padding()
  }
}
