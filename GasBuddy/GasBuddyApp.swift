//
//  GasBuddyApp.swift
//  GasBuddy
//
//  Created by Yuhan Liu on 12/22/21.
//

import SwiftUI

@main
struct GasBuddyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
