//
//  ContentView.swift
//  GasBuddy
//
//  Created by Yuhan Liu on 12/22/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
  
  @State private var showingNewTripView: Bool = false
  @State private var showingDashboard: Bool
  
  init(showingDashboard: Bool = true) {
    self.showingDashboard = showingDashboard
  }
  
  var body: some View {
    Group {
      if self.showingDashboard {
        DashboardView(
          showingDashboard: self.$showingDashboard,
          showingNewTripView: self.$showingNewTripView)
          .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)))
      } else {
        MyTripsView(showingDashboard: self.$showingDashboard)
          .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
      }
    }
    .animation(.easeInOut(duration: 0.2), value: self.showingDashboard)
    .sheet(isPresented: self.$showingNewTripView) {
      NewTripView(isPresented: self.$showingNewTripView)
    }
  }
  
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      ContentView()
      ContentView(showingDashboard: false)
    }.environment(
      \.managedObjectContext,
       PersistenceController.preview.container.viewContext)
  }
}
