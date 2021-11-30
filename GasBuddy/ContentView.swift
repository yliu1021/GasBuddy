//
//  ContentView.swift
//  GasBuddy
//
//  Created by Yuhan Liu on 11/30/21.
//

import SwiftUI

struct ContentView: View {

  @State private var presentingFillView = false

  var body: some View {
    VStack {
      Button("Add") {
        self.presentingFillView = true
      }
    }
    .popover(isPresented: $presentingFillView) {
      FillView(isPresented: $presentingFillView)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
