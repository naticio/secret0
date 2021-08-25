//
//  Secret0App.swift
//  Secret0
//
//  Created by Nat-Serrano on 8/24/21.
//

import SwiftUI

@main
struct Secret0App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
