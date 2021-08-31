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
    @AppStorage("isOnboarding") var isOnboarding = true
   
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
           LaunchView()
            .environmentObject(ContentModel())
            .environmentObject(LocationModel())
        //declare environment object to cascade my viewModel throughout the app sub views
        }
    }
}
