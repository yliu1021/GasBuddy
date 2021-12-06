//
//  PastTripsView.swift
//  GasBuddy
//
//  Created by Yuhan Liu on 12/1/21.
//

import SwiftUI
import simd

struct PastTripsView: View {

  @EnvironmentObject private var authStatus: AuthStatus
  @StateObject private var state = PastTripsViewModel()
  @State private var presentingNewTripView = false

  var body: some View {
    VStack(alignment: .leading) {
      Text("Past Trips")
        .font(.heavy(size: 50))
        .padding()
      List{
        ForEach(state.pastTrips) { trip in
          TripView(trip: trip)
        }
        .onDelete { indices in
          for index in indices {
            state.removeTrip(at: index)
          }
        }
      }
      .listStyle(.plain)
      Button {
        self.presentingNewTripView = true
      } label: {
        Text("New Trip")
          .frame(maxWidth: .infinity)
      }
      .padding()
      .buttonStyle(AppButtonStyle())
    }
    .popover(
      isPresented: self.$presentingNewTripView,
      content: {
        GasTripView(isPresented: self.$presentingNewTripView)
      }
    )
    .onAppear {
      state.authStatus = self.authStatus
      state.startListening()
    }
    .onDisappear {
      state.stopListening()
    }
  }
}

struct PastTripsView_Previews: PreviewProvider {
  static let authStatus: AuthStatus = {
    let authStatus = AuthStatus()
    authStatus.uid = "IyEDbAPqlMZ0Qv9sjKGTyWMGgb22"
    return authStatus
  }()

  static var previews: some View {
    PastTripsView()
      .environmentObject(authStatus)
  }
}
