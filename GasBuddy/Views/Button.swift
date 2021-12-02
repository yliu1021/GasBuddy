//
//  Button.swift
//  GasBuddy
//
//  Created by Yuhan Liu on 12/1/21.
//

import SwiftUI

struct AppButtonStyle: ButtonStyle {
  private var radius: CGFloat

  init(isRounded: Bool = true) {
    radius = isRounded ? 20 : 0
  }

  func makeBody(configuration: Configuration) -> some View {
    configuration
      .label
      .padding()
      .background(Color.black)
      .foregroundColor(.white)
      .cornerRadius(self.radius)
  }
}

struct Button_Previews: PreviewProvider {
  static var previews: some View {
    Button {
    } label: {
      Text("some label")
    }
    .buttonStyle(AppButtonStyle())
    .previewLayout(.sizeThatFits)
    .padding()
  }
}
