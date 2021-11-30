//
//  FillView.swift
//  GasBuddy
//
//  Created by Yuhan Liu on 11/30/21.
//

import SwiftUI

struct FillView: View {
  @Binding var isPresented: Bool

  @StateObject private var state = FillViewModel()

  enum Field: Hashable {
    case totalPrice
    case gallons
  }
  @FocusState private var focusedField: Field?
  @State private var totalPriceValid = true
  @State private var gallonsValid = true
  @State private var saving = false
  @State private var saveError = false

  let formatter: Formatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    return formatter
  }()

  var body: some View {
    VStack(alignment: .center, content: {
      Spacer()
      if saving {
        VStack {
          Text("Saving...")
          ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
        }
      }
      if saveError {
        Text("Error saving! Please try again later.")
          .foregroundColor(Color.red)
      }
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
        .font(.system(size: 80, weight: .bold, design: .rounded))
        Text("Total Price").font(.caption)
      }
      Group {
        NumberFieldView(
          title: "Gallons",
          text: $state.gallons,
          prompt: "0",
          valid: $gallonsValid)
          .focused($focusedField, equals: .gallons)
          .font(.system(size: 60, weight: .bold, design: .rounded))
        Text("Gallons").font(.caption)
      }
      Spacer()
      Button {
        let newFocusedField = validate()
        self.focusedField = newFocusedField
        if newFocusedField == nil {
          // nil means the numbers are good
          saveError = false
          saving = true
          state.save { success in
            saving = false
            if success {
              self.isPresented = false
            } else {
              saveError = true
            }
          }
        }
      } label: {
        Text("Done")
          .foregroundColor(Color.white)
          .frame(height: 44)
          .frame(maxWidth: .infinity)
          .animation(nil, value: focusedField)
          .background(focusedField != nil ? Color.black : Color.white)
          .animation(.easeIn(duration: 0.1), value: focusedField)
      }
      .disabled(focusedField == nil)
    })
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
      .frame(maxWidth: 300)
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
    FillView(isPresented: .constant(true))
  }
}
