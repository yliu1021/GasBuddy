//
//  GasTripInputView.swift
//  GasBuddy
//
//  Created by Yuhan Liu on 12/1/21.
//

import SwiftUI

struct GasTripInputView: View {
  @Binding var totalPrice: String
  @Binding var gallons: String
  @Binding var station: String
  @Binding var address: String

  var body: some View {
    VStack {
      CaptionedTextField(
        prompt: "0.00",
        text: $totalPrice,
        caption: "Total price"
      )
      .keyboardType(.decimalPad)
      CaptionedTextField(
        prompt: "0",
        text: $gallons,
        caption: "Gallons"
      )
      .keyboardType(.decimalPad)
      CaptionedTextField(
        prompt: "Station",
        text: $station,
        caption: "Station")
      CaptionedTextField(
        prompt: "Address",
        text: $address,
        caption: "Address")
    }
  }
}

struct GasTripInputView_Previews: PreviewProvider {
  static var previews: some View {
    GasTripInputView(
      totalPrice: .constant(""),
      gallons: .constant(""),
      station: .constant(""),
      address: .constant("")
    )
    .previewLayout(.sizeThatFits)
    .padding()
    .previewDisplayName("Default preview")
  }
}
