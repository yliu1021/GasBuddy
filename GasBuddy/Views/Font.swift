//
//  Font.swift
//  GasBuddy
//
//  Created by Yuhan Liu on 12/1/21.
//

import SwiftUI

extension Font {
  static func heavy(size: CGFloat) -> Font {
    return Font.system(size: size, weight: .heavy, design: .rounded)
  }

  static func medium(size: CGFloat) -> Font {
    return Font.system(size: size, weight: .medium, design: .rounded)
  }
}
