//
//  GasTripView.swift
//  GasBuddy
//
//  Created by Yuhan Liu on 11/30/21.
//

import SwiftUI

struct GasTripView: View {

  @Binding var isPresented: Bool

  @EnvironmentObject private var authStatus: AuthStatus
  @StateObject var state = GasTripViewModel()

  var body: some View {
    VStack {
      Text("New Gas Trip")
        .font(.heavy(size: 50))
        .padding(.top, 20)
      Spacer()
      GasTripInputView(
        totalPrice: $state.totalPriceString,
        gallons: $state.gallonsString,
        station: $state.stationString,
        address: $state.addressString)
      Spacer()
      GasTripLocationStatusView(locationStatus: $state.locationStatus)
      Button {
        state.save { success in
          self.isPresented = !success
        }
      } label: {
        Text("Submit")
          .frame(maxWidth: .infinity)
      }
      .buttonStyle(AppButtonStyle())
    }
    .padding()
    .onAppear {
      state.authStatus = self.authStatus
      state.requestAuthorization()
      state.startUpdatingLocation()
    }
    .onDisappear {
      state.stopUpdatingLocation()
    }
    .onChange(of: state.locationStatus) { newValue in
      print("\(newValue)")
      if case .locatedWithAddess(_, station: let station, address: let address) = newValue {
        if state.stationString.isEmpty {
          state.stationString = station
        }
        if state.addressString.isEmpty {
          state.addressString = address
        }
      }
    }
  }
}

struct GasTripView_Previews: PreviewProvider {
  static var previews: some View {
    GasTripView(isPresented: .constant(true))
  }
}
