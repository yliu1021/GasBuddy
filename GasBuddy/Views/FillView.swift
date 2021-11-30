//
//  FillView.swift
//  GasBuddy
//
//  Created by Yuhan Liu on 11/30/21.
//

import SwiftUI

struct FillView: View {
  enum Field: Hashable {
    case totalPrice
    case gallons
  }

  @StateObject private var state = FillViewModel()

  @FocusState private var focusedField: Field?
  @State private var totalPriceValid = true
  @State private var gallonsValid = true

  let formatter: Formatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    return formatter
  }()

  var body: some View {
    VStack(alignment: .center, content: {
      Spacer()
      Group {
        HStack {
          Text("$")
          NumberFieldView(
            title: "Total Price",
            text: $state.totalPrice,
            prompt: "0.00",
            valid: $totalPriceValid)
            .focused($focusedField, equals: .totalPrice)
        }
        .font(.largeTitle)
        Text("Total Price").font(.caption)
      }
      Group {
        NumberFieldView(
          title: "Gallons",
          text: $state.gallons,
          prompt: "0",
          valid: $gallonsValid)
          .focused($focusedField, equals: .gallons)
          .font(.title)
        Text("Gallons").font(.caption)
      }
      Spacer()
      Button("Done") {
        focusedField = validate()
      }
      .frame(height: focusedField != nil ? 44 : 0)
      .frame(maxWidth: .infinity)
      .background(Color.black)
      .foregroundColor(Color.white)
    })
      .onAppear {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
          // hacky workaround to set default focus on totalPrice text field
          self.focusedField = .totalPrice
        })
      }
  }

  func validate() -> Field? {
    switch state.validate() {
    case .valid:
      totalPriceValid = true
      gallonsValid = true
    case .invalid(reason: let reason):
      totalPriceValid = !reason.contains(.totalPriceWrong)
      gallonsValid = !reason.contains(.gallonsWrong)
      if !totalPriceValid {
        return .totalPrice
      } else if !gallonsValid {
        return .gallons
      }
    }
    return nil
  }
}

struct NumberFieldView: View {
  let title: String
  @Binding var text: String
  let prompt: String

  @Binding var valid: Bool

  var body: some View {
    TextField(
      title,
      text: $text,
      prompt: Text(prompt))
      .keyboardType(.decimalPad)
      .frame(maxWidth: 200)
      .fixedSize()
      .padding(2)
      .overlay(
        RoundedRectangle(cornerRadius: 8)
          .stroke(
            valid ? Color.clear : Color.red,
            lineWidth: 1)
          .animation(.easeIn(duration: 0.1), value: valid)
      )
  }
}

struct FillView_Previews: PreviewProvider {
  static var previews: some View {
    FillView()
  }
}
