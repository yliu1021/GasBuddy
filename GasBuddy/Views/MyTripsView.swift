//
//  MyTripsView.swift
//  GasBuddy
//
//  Created by Yuhan Liu on 12/23/21.
//

import SwiftUI

struct MyTripsView: View {

  @Binding var showingDashboard: Bool
  
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
          indexSet.map { trips[$0] }.forEach(self.viewContext.delete(_:))
          do {
            try self.viewContext.save()
          } catch {}
        }
      }
      .listStyle(.plain)
      .navigationTitle(Text("My Trips"))
      .toolbar {
        ToolbarItemGroup(placement: .bottomBar) {
          Button {
            self.showingDashboard = true
          } label: {
            HStack {
              Image(systemName: "chevron.backward.circle.fill")
              Text("Back")
            }
          }
          Spacer()
        }
      }
    }.navigationViewStyle(.stack)
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
    MyTripsView(showingDashboard: .constant(false))
      .environment(
        \.managedObjectContext,
         PersistenceController.preview.container.viewContext)
  }
}
