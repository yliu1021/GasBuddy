//
//  DashboardView.swift
//  GasBuddy
//
//  Created by Yuhan Liu on 12/23/21.
//

import SwiftUI
import MapKit

struct DashboardView: View {
  
  @State private var showingNewTripView: Bool = false
  
  var body: some View {
    NavigationView {
      ScrollView {
        Group {
          MonthSummaryView()
        }
      }
      .toolbar {
        Button {
          self.showingNewTripView = true
        } label: {
          Image(systemName: "plus.circle.fill")
        }
      }
      .navigationTitle("Dashboard")
    }
    .sheet(isPresented: self.$showingNewTripView) {
      NewTripView(isPresented: self.$showingNewTripView)
    }
  }
  
}

struct DashboardView_Previews: PreviewProvider {
  static var previews: some View {
    DashboardView()
      .environment(
        \.managedObjectContext,
         PersistenceController.preview.container.viewContext)
  }
}
