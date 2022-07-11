//
//  MyTripsView.swift
//  GasBuddy
//
//  Created by Yuhan Liu on 12/23/21.
//

import SwiftUI

struct MyTripsView: View {
  
  @State private var showingNewTripView: Bool = false
  
  @Environment(\.managedObjectContext) private var viewContext
  @FetchRequest(
    entity: GasTrip.entity(),
    sortDescriptors: [NSSortDescriptor(keyPath: \GasTrip.date, ascending: false)],
    animation: Animation.default
  ) private var trips: FetchedResults<GasTrip>
  
  var body: some View {
    NavigationView {
      List {
        ForEach(trips) { trip in
          TripCellView(trip: trip).padding(2)
        }.onDelete { indexSet in
          indexSet.forEach {
            self.viewContext.delete(self.trips[$0])
          }
          do {
            try self.viewContext.save()
          } catch {}
        }
      }
      .listStyle(.plain)
      .toolbar {
        Button {
          self.showingNewTripView = true
        } label: {
          Image(systemName: "plus.circle.fill")
        }
      }
      .navigationTitle("My Trips")
    }
    .sheet(isPresented: self.$showingNewTripView) {
      NewTripView(isPresented: self.$showingNewTripView)
    }
  }
}

struct TripCellView: View {
  
  var trip: GasTrip
  
  init(trip: GasTrip) {
    self.trip = trip
  }
  
  private var currencyFormatter: Formatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    return formatter
  }()
  
  private var numberFormatter: Formatter = {
    let formatter = NumberFormatter()
    formatter.minimumFractionDigits = 0
    formatter.maximumFractionDigits = 3
    return formatter
  }()
  
  private var dateFormatter: Formatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    formatter.dateStyle = .medium
    return formatter
  }()
  
  private var priceFormatter: Formatter = {
    let formatter = NumberFormatter()
    formatter.minimumFractionDigits = 3
    formatter.maximumFractionDigits = 3
    return formatter
  }()
  
  private var price: Double {
    return self.trip.totalPrice / self.trip.gallons
  }
  
  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        HStack(alignment: .lastTextBaseline) {
          Text(currencyFormatter.string(for: self.trip.totalPrice)!)
            .font(.body.bold())
          if let station = self.trip.station {
            Text(station)
              .font(.caption)
          }
        }
        Text("\(numberFormatter.string(for: self.trip.gallons)!) gals")
          .font(.caption)
      }
      Spacer()
      VStack(alignment: .trailing) {
        Text("$/gal \(priceFormatter.string(for: self.price)!)")
        Text(dateFormatter.string(for: self.trip.date!)!)
          .font(.caption.italic())
      }
    }
  }
  
}

struct MyTripsView_Previews: PreviewProvider {
  static var previews: some View {
    MyTripsView()
      .environment(
        \.managedObjectContext,
         PersistenceController.preview.container.viewContext)
  }
}
