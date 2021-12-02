//
//  TripView.swift
//  GasBuddy
//
//  Created by Yuhan Liu on 12/1/21.
//

import SwiftUI

struct TripView: View {
  var trip: GasTrip

  private var pricePerGallon: Double {
    return trip.totalPrice / trip.gallons
  }

  private let currencyFormatter: Formatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    return formatter
  }()

  private let numberFormatter: Formatter = {
    let formatter = NumberFormatter()
    formatter.maximumFractionDigits = 1
    formatter.minimumFractionDigits = 0
    return formatter
  }()

  private let dateFormatter: Formatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
  }()

  var body: some View {
    VStack(alignment: .leading) {
      HStack(alignment: .lastTextBaseline) {
        Text(trip.station)
          .font(.heavy(size: 20))
        Spacer()
        Text(dateFormatter.string(for: trip.date)!)
          .font(.medium(size: 14))
      }
      HStack(alignment: .lastTextBaseline) {
        Text(
          "Tot: \(currencyFormatter.string(for: trip.totalPrice)!), "
            + "Gal: \(numberFormatter.string(for: trip.gallons)!)")
        Spacer()
        Text("$/Gal: \(currencyFormatter.string(for: self.pricePerGallon)!)")
      }
      .font(.medium(size: 16))
    }
  }
}

struct TripView_Previews: PreviewProvider {
  static var previews: some View {
    TripView(
      trip: GasTrip(
        userID: "",
        totalPrice: 42,
        gallons: 21,
        station: "Costco",
        streetAddress: "Landfair Ave",
        date: Date())
    )
    .previewLayout(.sizeThatFits)
    .padding()
  }
}
