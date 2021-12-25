//
//  ContentView.swift
//  GasBuddy
//
//  Created by Yuhan Liu on 12/22/21.
//

import SwiftUI
import CoreData

struct ContentView: View {

  static var toolBarHeight: CGFloat = 80
  
  @State private var showingNewTripView: Bool = false
  @State private var showingDashboard: Bool
  
  init(showingDashboard: Bool = true) {
    self.showingDashboard = showingDashboard
  }
  
  var body: some View {
    VStack(spacing: 0) {
      Group {
        if self.showingDashboard {
          DashboardView()
            .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)))
        } else {
          MyTripsView()
            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
        }
      }
      .animation(.easeInOut(duration: 0.2), value: self.showingDashboard)
      toolbar
        .frame(height: ContentView.toolBarHeight)
        .background(.ultraThinMaterial)
    }
    .sheet(isPresented: self.$showingNewTripView) {
      NewTripView(isPresented: self.$showingNewTripView)
    }
  }

  var toolbar: some View {
    HStack {
      Button {
        self.showingNewTripView = true
      } label: {
        VStack(alignment: .leading) {
          Image(systemName: "plus.circle.fill")
            .resizable()
            .aspectRatio(1, contentMode: .fit)
          Text("New Trip")
            .font(.caption)
        }
      }
      Spacer()
      Button {
        self.showingDashboard.toggle()
      } label: {
        VStack(alignment: .trailing) {
          if self.showingDashboard {
            Image(systemName: "list.bullet.circle.fill")
              .resizable()
              .aspectRatio(1, contentMode: .fit)
            Text("My Trips")
              .font(.caption)
          } else {
            Image(systemName: "fuelpump.circle.fill")
              .resizable()
              .aspectRatio(1, contentMode: .fit)
            Text("Trip Summary")
              .font(.caption)
          }
        }
      }
    }
    .padding(10)
    .padding([.leading, .trailing], 48)
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
