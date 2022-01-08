//
//  DashboardView.swift
//  GasBuddy
//
//  Created by Yuhan Liu on 12/23/21.
//

import SwiftUI
import MapKit

struct DashboardView: View {
  
  @Binding var showingDashboard: Bool
  @Binding var showingNewTripView: Bool

  var body: some View {
    VStack {
      ScrollView {
        Group {
          MonthSummaryView()
        }
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(radius: 1)
        .padding()
      }.background(Color(.secondarySystemBackground))
      Spacer()
      toolbar.frame(height: 80)
    }
    .frame(maxWidth: .infinity)
  }
  
  var toolbar: some View {
    HStack {
      Button {
        self.showingNewTripView = true
      } label: {
        VStack {
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
        VStack {
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
    .padding(12)
    .padding([.leading, .trailing], 48)
  }

}

struct DashboardView_Previews: PreviewProvider {
  static var previews: some View {
    DashboardView(showingDashboard: .constant(true), showingNewTripView: .constant(false))
      .environment(
        \.managedObjectContext,
         PersistenceController.preview.container.viewContext)
  }
}
