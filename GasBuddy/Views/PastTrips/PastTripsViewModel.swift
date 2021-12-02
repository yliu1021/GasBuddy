//
//  PastTripsViewModel.swift
//  GasBuddy
//
//  Created by Yuhan Liu on 12/1/21.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

class PastTripsViewModel: ObservableObject {

  @Published var pastTrips: [GasTrip] = []

  private let tripCollection = Firestore.firestore().collection("trips")
  private var listener: ListenerRegistration?

  func startListening() {
    self.stopListening()
    self.listener = tripCollection.addSnapshotListener { snapshot, error in
      guard let snapshot = snapshot else {
        print("Snapshot listener error: \(error!)")
        return
      }
      let documents = snapshot.documents
      let trips = documents.compactMap { try? $0.data(as: GasTrip.self) }
      self.pastTrips = trips.sorted { tripA, tripB in
        tripA.date < tripB.date
      }
    }
  }

  func stopListening() {
    self.listener?.remove()
  }

}
