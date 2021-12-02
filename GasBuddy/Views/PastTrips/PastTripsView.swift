//
//  PastTripsView.swift
//  GasBuddy
//
//  Created by Yuhan Liu on 12/1/21.
//

import SwiftUI

struct PastTripsView: View {

  @EnvironmentObject private var authStatus: AuthStatus
  @StateObject private var state = PastTripsViewModel()
  @State private var presentingNewTripView = false

  var body: some View {
    NavigationView {
      VStack {
        ScrollView(.vertical, showsIndicators: true) {
          ForEach(state.pastTrips) { trip in
            TripView(trip: trip)
              .padding(.vertical, 4)
          }
          .padding()
        }
        Button {
          self.presentingNewTripView = true
        } label: {
          Text("New Trip")
            .frame(maxWidth: .infinity)
        }
        .padding()
        .buttonStyle(AppButtonStyle())
      }
      .navigationTitle("Past Trips")
      .navigationBarTitleDisplayMode(.automatic)
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
  static var previews: some View {
    PastTripsView()
  }
}
