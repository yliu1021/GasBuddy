//
//  FillViewModel.swift
//  GasBuddy
//
//  Created by Yuhan Liu on 11/30/21.
//

import Foundation

class FillViewModel: ObservableObject {
  struct InvalidField: OptionSet {
    let rawValue: Int

    static let totalPriceWrong = InvalidField(rawValue: 1 << 0)
    static let gallonsWrong = InvalidField(rawValue: 1 << 1)
  }
  enum ValidationResult {
    case valid
    case invalid(reason: InvalidField)
  }

  @Published var totalPrice: String = ""
  @Published var gallons: String = ""

  private let formatter: Formatter = {
    let formatter = NumberFormatter()
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
    return formatter
  }()

  func validate() -> ValidationResult {
    var invalidFields: InvalidField = []
    if let totalPrice = Double(totalPrice) {
      if totalPrice > 300 {
        invalidFields.insert(.totalPriceWrong)
      }
    } else {
      invalidFields.insert(.totalPriceWrong)
    }
    if let gallons = Double(gallons) {
      if gallons > 50 {
        invalidFields.insert(.gallonsWrong)
      }
    } else {
      invalidFields.insert(.gallonsWrong)
    }
    if let totalPrice = Double(totalPrice) {
      self.totalPrice = formatter.string(for: totalPrice)!
    }
    if invalidFields.isEmpty {
      return .valid
    } else {
      return .invalid(reason: invalidFields)
    }
  }

  func save(onDone: @escaping (_ success: Bool) -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 1...2)) {
      onDone(Bool.random())
    }
  }
}
