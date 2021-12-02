//
//  GasBuddyApp.swift
//  GasBuddy
//
//  Created by Yuhan Liu on 11/30/21.
//

import Firebase
import SwiftUI

@main
struct GasBuddyApp: App {
  init() {
    FirebaseApp.configure()
  }

  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
