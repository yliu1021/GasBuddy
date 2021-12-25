//
//  NewTripView.swift
//  GasBuddy
//
//  Created by Yuhan Liu on 12/23/21.
//

import SwiftUI
import MapKit

struct NewTripView: View {
  
  @Binding var isPresented: Bool

  @Environment(\.managedObjectContext) private var viewContext

  @StateObject private var locationState = LocationViewModel()
  @StateObject private var gasStationState = GasStationSearchViewModel()
  @State private var totalPriceStr: String = ""
  @State private var numGallonsStr: String = ""
  @State private var gasStationStr: String = ""

  var body: some View {
    VStack {
      Text("New Trip").font(.largeTitle)
      Spacer()
      Group {
        CaptionedTextField(
          name: "*Total Price",
          text: self.$totalPriceStr,
          prompt: "0.00",
          prefix: "$")
          .keyboardType(.decimalPad)
        CaptionedTextField(
          name: "*Num Gallons",
          text: self.$numGallonsStr,
          prompt: "0.000")
          .keyboardType(.decimalPad)
        CaptionedTextField(
          name: "Gas Station",
          text: self.$gasStationStr,
          prompt: "Gas Station")
      }
      LocationView(locationState: locationState).padding()
        .onChange(of: self.locationState.status) { newValue in
          if case .located(let location) = newValue {
            self.gasStationState.find(near: location) { station in
              guard let stationName = station.name else {
                return
              }
              guard self.gasStationStr.isEmpty else {
                return
              }
              self.gasStationStr = stationName
            }
          }
        }
      Spacer()
      HStack {
        Text("*required").font(.caption2)
        Spacer()
      }
      Button {
        self.save()
      } label: {
        HStack {
          Image(systemName: "plus.app")
          Text("Add Trip")
        }
        .padding()
        .frame(height: 42)
      }
      .foregroundColor(.white)
      .background(Color.accentColor)
      .cornerRadius(16)
    }
    .padding()
  }
  
  private func save() {
    guard let totalPrice = Double(self.totalPriceStr) else {
      return
    }
    guard let numGallons = Double(self.numGallonsStr) else {
      return
    }
    let gasTrip = GasTrip(context: self.viewContext)
    if case .located(let location) = self.locationState.status {
      let coord = location.coordinate
      gasTrip.longitude = coord.longitude
      gasTrip.latitude = coord.latitude
    }
    gasTrip.totalPrice = totalPrice
    gasTrip.gallons = numGallons
    gasTrip.station = self.gasStationStr
    gasTrip.date = Date()
    do {
      try self.viewContext.save()
      self.isPresented = false
    } catch {}
  }
  
}

struct CaptionedTextField: View {
  
  var name: String
  @Binding var text: String
  var prompt: String
  var prefix: String = ""
  
  var body: some View {
    VStack(alignment: .leading) {
      HStack(spacing: 0) {
        if prefix.count != 0 {
          Text(prefix)
        }
        TextField(
          self.name,
          text: self.$text,
          prompt: Text(self.prompt)
        )
      }.font(.title)
      Text(name)
        .font(.caption)
    }
  }
  
}

struct NewTripView_Previews: PreviewProvider {
  static var previews: some View {
    NewTripView(isPresented: .constant(true))
  }
}
