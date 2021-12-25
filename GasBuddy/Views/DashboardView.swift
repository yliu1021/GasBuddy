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

  @FetchRequest private var trips: FetchedResults<GasTrip>
  
  private var now = Date()
  
  init(showingDashboard: Binding<Bool>, showingNewTripView: Binding<Bool>) {
    self._showingDashboard = showingDashboard
    self._showingNewTripView = showingNewTripView
    let calendar = Calendar.autoupdatingCurrent
    var components = calendar.dateComponents([.month, .year], from: now)
    components.day = 1
    guard let monthStart = calendar.date(from: components) else {
      fatalError("Unable to get month start date")
    }
    self._trips = FetchRequest<GasTrip>(
      entity: GasTrip.entity(),
      sortDescriptors: [],
      predicate: NSPredicate(format: "date >= %@", monthStart as NSDate))
  }

  private var currMonthString: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMMM yyyy"
    return dateFormatter.string(from: now)
  }
  
  private var tripCountString: String {
    if trips.count == 1 {
      return "1 time"
    } else {
      return "\(trips.count) times"
    }
  }
  
  private var totalCostString: String {
    var price: Double = 0
    for trip in self.trips {
      price += trip.totalPrice
    }
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    return formatter.string(from: NSNumber(floatLiteral: price))!
  }
  
  private var totalGallonsString: String {
    var gallons: Double = 0
    for trip in self.trips {
      gallons += trip.gallons
    }
    let formatter = NumberFormatter()
    formatter.minimumFractionDigits = 0
    formatter.maximumFractionDigits = 3
    let gallonNumStr = formatter.string(from: NSNumber(floatLiteral: gallons))!
    if gallons == 1 {
      return "1 gallon"
    } else {
      return "\(gallonNumStr) gallons"
    }
  }
  
  var body: some View {
    VStack {
      Spacer()
      HStack {
        VStack(alignment: .leading) {
          Text("This month")
          Text(currMonthString).font(.largeTitle)
          Text("you've gotten gas")
          Text(tripCountString).font(.title)
          Text("and spent")
          Text(totalCostString).font(.title)
          Text("for")
          Text(totalGallonsString).font(.title)
        }.padding()
        Spacer()
      }
      TripsMapView(trips: self.trips.compactMap { $0 })
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
