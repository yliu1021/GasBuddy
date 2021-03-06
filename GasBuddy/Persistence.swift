//
//  Persistence.swift
//  GasBuddy
//
//  Created by Yuhan Liu on 12/22/21.
//

import CoreData

struct PersistenceController {
  static let shared = PersistenceController()

  static var preview: PersistenceController = {
    let result = PersistenceController(inMemory: true)
    let viewContext = result.container.viewContext
    for i in 0..<50 {
      let trip = GasTrip(context: viewContext)
      trip.latitude = Double.random(in: 0..<180)
      trip.longitude = Double.random(in: 0..<180)
      trip.gallons = Double.random(in: 14..<25)
      trip.totalPrice = trip.gallons * Double.random(in: 3..<5)
      trip.station = "Brand \(i)"
      trip.date = Date(timeIntervalSinceNow: -TimeInterval.random(in: 0..<32_000_000))
    }
    do {
      try viewContext.save()
    } catch {
      // Replace this implementation with code to handle the error appropriately.
      // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      let nsError = error as NSError
      fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    }
    return result
  }()

  let container: NSPersistentCloudKitContainer

  init(inMemory: Bool = false) {
    container = NSPersistentCloudKitContainer(name: "GasBuddy")
    if inMemory {
      container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
    }
    container.viewContext.automaticallyMergesChangesFromParent = true
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

        /*
        Typical reasons for an error here include:
        * The parent directory does not exist, cannot be created, or disallows writing.
        * The persistent store is not accessible, due to permissions or data protection when the device is locked.
        * The device is out of space.
        * The store could not be migrated to the current model version.
        Check the error message to determine what the actual problem was.
        */
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
  }
}
