//
//  ContentView.swift
//  GasBuddy
//
//  Created by Yuhan Liu on 12/22/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
  
  @State private var showingDashboard: Bool
  
  init(showingDashboard: Bool = true) {
    self.showingDashboard = showingDashboard
  }
  
  var body: some View {
    TabView {
      DashboardView()
        .tabItem {
          Image(systemName: "fuelpump")
          Text("Dashboard")
        }
      MyTripsView()
        .tabItem {
          Image(systemName: "list.bullet")
          Text("My Trips")
        }
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
