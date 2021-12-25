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
  @State private var showingDashboard: Bool = true
  
  var body: some View {
    ZStack(alignment: .bottom) {
      Group {
        if self.showingDashboard {
          DashboardView()
            .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)))
        } else {
          MyTripsView()
            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
        }
      }
      .animation(.easeInOut, value: self.showingDashboard)
      toolbar
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
            .frame(width: 44, height: 44)
          Text("New Trip")
            .font(.caption)
        }
      }.padding()
      Spacer()
      Button {
        self.showingDashboard.toggle()
      } label: {
        VStack(alignment: .trailing) {
          if self.showingDashboard {
            Image(systemName: "list.bullet.circle.fill")
              .resizable()
              .frame(width: 44, height: 44)
            Text("My Trips")
              .font(.caption)
          } else {
            Image(systemName: "fuelpump.circle.fill")
              .resizable()
              .frame(width: 44, height: 44)
            Text("Trip Summary")
              .font(.caption)
          }
        }
      }.padding()
    }.padding()
  }
  
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .environment(
        \.managedObjectContext,
         PersistenceController.preview.container.viewContext)
  }
}
