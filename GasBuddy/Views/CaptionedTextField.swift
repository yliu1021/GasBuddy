//
//  CaptionedTextField.swift
//  GasBuddy
//
//  Created by Yuhan Liu on 12/1/21.
//

import SwiftUI

struct CaptionedTextField: View {
  var prompt: String
  @Binding var text: String
  var caption: String
  var fontSize: CGFloat = 30

  var body: some View {
    VStack(alignment: .leading) {
      TextField(prompt, text: $text)
        .font(.text(size: fontSize))
      Text(caption)
        .font(.caption)
    }
  }
}

struct CaptionedTextField_Previews: PreviewProvider {
  static var previews: some View {
    CaptionedTextField(
      prompt: "some prompt",
      text: .constant(""),
      caption: "some caption",
      fontSize: 30)
      .previewLayout(.sizeThatFits)
      .padding()
      .previewDisplayName("Default preview")
  }
}
