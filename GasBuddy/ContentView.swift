//
//  ContentView.swift
//  GasBuddy
//
//  Created by Yuhan Liu on 11/30/21.
//

import FirebaseAuth
import SwiftUI

class AuthStatus: ObservableObject {
  @Published var uid: String?
}

struct ContentView: View {

  @StateObject private var authStatus = AuthStatus()

  var body: some View {
    Group {
      if authStatus.uid != nil {
        PastTripsView()
      } else {
        Text("Logging in...")
        ProgressView()
      }
    }
    .environmentObject(authStatus)
    .onAppear {
      self.login()
      Auth.auth().addStateDidChangeListener { _, user in
        authStatus.uid = user?.uid
      }
    }
  }

  func login() {
    Auth.auth().signInAnonymously { _, error in
      if let error = error {
        print("Error signing in: \(error)")
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
