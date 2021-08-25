//
//  Secret0App.swift
//  Secret0
//
//  Created by Nat-Serrano on 8/24/21.
//

import SwiftUI
import Firebase

@main
struct Secret0App: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            LoginView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
