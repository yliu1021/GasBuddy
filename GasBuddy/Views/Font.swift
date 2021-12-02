//
//  Font.swift
//  GasBuddy
//
//  Created by Yuhan Liu on 12/1/21.
//

import SwiftUI

extension Font {
  static func text(size: CGFloat) -> Font {
    return Font.system(size: size, weight: .heavy, design: .rounded)
  }
}
